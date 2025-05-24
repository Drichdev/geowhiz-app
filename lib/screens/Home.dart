import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geowhiz/screens/Categories/Aleatoire.dart';
import 'package:geowhiz/screens/Categories/Area.dart';
import 'package:geowhiz/screens/Categories/Capitals.dart';
import 'package:geowhiz/screens/Categories/Langue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Categories/Flags.dart';
import 'Categories/Regions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = 'name';
  String profil = 'assets/images/prof19.png';
  int points = 0;
  List<Map<String, dynamic>> recentGames = [];


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList("history") ?? [];

    setState(() {
      name = prefs.getString("nom") ?? "Utilisateur";
      profil = prefs.getString("profil") ?? "assets/images/prof19.png";
      points = prefs.getInt("points") ?? 0;

      // Parser l'historique
      recentGames = history.map((e) => jsonDecode(e)).cast<Map<String, dynamic>>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Drapeaux', 'icon': Icons.flag_rounded, 'screen':  Flags()},
      {'title': 'Régions', 'icon': Icons.public_rounded, 'screen': const Regions()},
      {'title': 'Capitales', 'icon': Icons.location_city_rounded, 'screen': const Capitals()},
      {'title': 'Tailles', 'icon': Icons.map_rounded, 'screen': const Area()},
      {'title': 'Langues', 'icon': Icons.language_rounded, 'screen': const Langue()},
      {'title': 'Aléatoire', 'icon': Icons.all_inclusive_rounded, 'screen': const Aleatoire()},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER PROFIL
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(profil),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 18, fontFamily: 'SpaceMono')),
                        const Text('Prêt à jouer !', style: TextStyle(fontFamily: 'SpaceMono')),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF7088FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  Row(
                        children: [
                          Icon(Icons.diamond, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(points.toString(), style: TextStyle(color: Colors.white, fontFamily: 'SpaceMono')),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),

                // CATÉGORIES
                const Text('Catégories', style: TextStyle(fontSize: 20, fontFamily: 'SpaceMono')),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      var cat = categories[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => cat['screen'] as Widget),
                          );
                          _loadUserData(); // <-- Rafraîchit après retour
                        },
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat['icon'] as IconData, size: 36),
                              const SizedBox(height: 8),
                              Text(cat['title'] as String, style: const TextStyle(fontFamily: 'SpaceMono')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // RÉCENTS
                const Text('Récents', style: TextStyle(fontSize: 20, fontFamily: 'SpaceMono')),
                const SizedBox(height: 10),
                if (recentGames.isNotEmpty) ...[
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: recentGames.length,
                      itemBuilder: (context, index) {
                        final game = recentGames[index];
                        final score = game['score'] as int;
                        final total = game['total'] as int;
                        final title = game['title'] as String;
                        final complete = score / total >= 0.8;

                        return _buildRecentCard(title, '$score/$total', complete);
                      },
                    ),
                  ),
                ] else Container(
                  alignment: Alignment.center,
                  child: Text('Pas de récent', style: TextStyle(fontFamily: 'SpaceMono'),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCard(String title, String progress, bool complete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF7088FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.theater_comedy_sharp, size: 48, color: Colors.black)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'SpaceMono')),
              Text('$progress', style: const TextStyle(fontFamily: 'SpaceMono')),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: complete ? Colors.green[300] : Colors.red[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              complete ? 'Complète' : 'Incomplète',
              style: const TextStyle(fontFamily: 'SpaceMono'),
            ),
          )
        ],
      ),
    );
  }
}
