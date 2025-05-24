import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../utils/TextStyles.dart';
import '../Scores.dart';

class Langue extends StatefulWidget {
  const Langue({super.key});

  @override
  _LangueState createState() => _LangueState();
}

class _LangueState extends State<Langue> with SingleTickerProviderStateMixin {
  List<dynamic> countries = [];
  dynamic currentCountry;
  String question = '';
  String correctAnswer = '';
  List<String> options = [];
  int score = 0;
  int currentQuestion = 1;
  int totalQuestions = 20;
  bool answered = false;
  String? selectedAnswer;

  late Timer _timer;
  int _timeLeft = 60;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initTimer();
    loadCountries();
  }

  void _initTimer() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(() {
      setState(() {});
    });

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreScreen(tete: 'Langue',score: score, totalQuestions: totalQuestions),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadCountries() async {
    String data = await rootBundle.loadString('assets/data/countries.json');
    countries = json.decode(data);

    // On filtre uniquement les pays qui ont une langue définie
    countries = countries.where((c) => c['language'] != null && c['language'].toString().isNotEmpty).toList();

    if (countries.isNotEmpty) {
      generateQuestion();
    }
  }

  void generateQuestion() {
    final random = Random();
    currentCountry = countries[random.nextInt(countries.length)];

    question = 'Quelle est la langue officielle de ${currentCountry['name']} ?';
    correctAnswer = currentCountry['language'];

    options = [correctAnswer];
    while (options.length < 4) {
      String randomLanguage = countries[random.nextInt(countries.length)]['language'];
      if (!options.contains(randomLanguage)) {
        options.add(randomLanguage);
      }
    }
    options.shuffle();

    setState(() {
      answered = false;
      selectedAnswer = null;
    });
  }

  void checkAnswer(String answer) {
    if (!answered) {
      setState(() {
        answered = true;
        selectedAnswer = answer;
        if (answer == correctAnswer) {
          score++;
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (currentQuestion < totalQuestions) {
          setState(() {
            currentQuestion++;
            generateQuestion();
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScoreScreen(tete: 'Langue',score: score, totalQuestions: totalQuestions),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(

        title: mediumTextBlack('Langues'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: LinearProgressIndicator(
            value: currentQuestion / totalQuestions,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 6,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: _animation.value,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timeLeft > 10 ? Colors.blue : Colors.red,
                    ),
                  ),
                ),
                Text(
                  '$_timeLeft',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft > 10 ? Colors.blue : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        'Question',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const Gap(1),
                      Text(
                        '$currentQuestion',
                        style: const TextStyle(fontSize: 16, color: Color(0xFF7088FF), fontWeight: FontWeight.bold),
                      ),
                      const Gap(1),
                      Text(
                        '/$totalQuestions',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      question,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...options.map((option) {
                    Color bgColor = Colors.grey[200]!;
                    Color textColor = Colors.black;

                    if (answered) {
                      if (option == correctAnswer) {
                        bgColor = Colors.green;
                        textColor = Colors.white;
                      } else if (option == selectedAnswer && option != correctAnswer) {
                        bgColor = Colors.red;
                        textColor = Colors.white;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: answered ? null : () => checkAnswer(option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
