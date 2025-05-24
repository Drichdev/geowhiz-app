import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String tete;

  ScoreScreen({required this.score, required this.totalQuestions, required this.tete});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  String name = 'name';
  String profil = 'assets/images/prof19.png';
  int totalPoints = 0;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("nom") ?? "Utilisateur";
      profil = prefs.getString("profil") ?? "assets/images/prof19.png";
      totalPoints = prefs.getInt("points") ?? 0;
    });
  }

  Future<void> _updateScore() async {
    final prefs = await SharedPreferences.getInstance();
    int oldPoints = prefs.getInt("points") ?? 0;
    int newPoints = oldPoints + (widget.score * 10);
    await prefs.setInt("points", newPoints);
    setState(() {
      totalPoints = newPoints;
    });
  }

  Future<void> _saveToHistory(String title, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];

    // Crée un nouvel item JSON
    Map<String, dynamic> newEntry = {
      "title": title,
      "score": score,
      "total": total
    };

    // Ajoute au début
    history.insert(0, jsonEncode(newEntry));

    // Garde seulement les 3 derniers
    if (history.length > 3) {
      history = history.sublist(0, 3);
    }

    await prefs.setStringList("history", history);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateScore();
    _saveToHistory(
        widget.tete, widget.score, widget.totalQuestions); // par exemple
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(profil),
              ),
              const Gap(15),
              Text(
                'Félicitations $name!',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'SpaceMono',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Votre Score',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SpaceMono',
                ),
              ),
              Text(
                '${widget.score}/${widget.totalQuestions}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SpaceMono',
                ),
              ),
              SizedBox(height: 30),
              Text(
                '${(widget.score * 10).round()} Points',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 42),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7088FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Retour à l\'accueil',
                style: TextStyle(fontFamily: 'SpaceMono', color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
