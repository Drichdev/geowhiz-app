import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geowhiz/screens/BottomBar.dart';
import 'package:geowhiz/utils/TextStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding/Onboarding.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoWhiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget _nextScreen = const Onboarding();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn != null && isLoggedIn) {
      String? status = prefs.getString("status");
      if (status == "user") {
        _nextScreen = Bottombar();
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnimatedSplashScreen(
          splash: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(height: 20, child: const Text("")),
                Container(
                  height: 150,
                  child: Image.asset('assets/images/logo.png',
                      height: 100, fit: BoxFit.cover),
                ),
                const Gap(5),
                Container(
                  height: 25,
                  child: mediumTextBlack("GeoWhiz"),

                )
              ],
            ),
          ),
          backgroundColor: Colors.white,
          nextScreen: _nextScreen,
          splashIconSize: 210,
          duration: 3000,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.black)),
    );
  }
}