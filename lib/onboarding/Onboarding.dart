import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geowhiz/onboarding/Profil.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7088FF),
      body: SafeArea(
        child: Column(
          children: [
            const Gap(10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/fun.png',
                        height: 230,
                        fit: BoxFit.cover,
                      ),
                      const Gap(40),
                      const Text(
                        "Transformer l'apprentissage en plaisir!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SpaceMono',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const Gap(20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "Apprendre avec nous, c'est s'amuser et se faire plaisir.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SpaceMono',
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        PageAnimationTransition(
                            page: Profil(),
                            pageAnimationType:
                            RightToLeftTransition()));
                  },
                  child: const Text(
                    'Suivant',
                    style: TextStyle(
                      fontFamily: 'SpaceMono',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
