import 'package:flutter/material.dart';
import 'package:geowhiz/screens/BottomBar.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final PageController _pageController = PageController(viewportFraction: 0.4);
  final TextEditingController _nameController = TextEditingController();
  int _selectedIndex = 1;
  bool _isButtonEnabled = false;


  final List<String> avatars = [
    'assets/profils/prof6.png',
    'assets/profils/prof7.png',
    'assets/profils/prof10.png',
    'assets/profils/prof12.png',
    'assets/profils/prof14.png',
    'assets/profils/prof15.png',
    'assets/profils/prof16.png',
    'assets/profils/prof17.png',
    'assets/profils/prof18.png',
    'assets/profils/prof19.png',

  ];

  Future<void> _saveLogin(String nom, String profil, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("nom", nom);
    await prefs.setString("status", status);
    await prefs.setString("profil", profil);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isButtonEnabled = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Configurez son profil',
                style: TextStyle(fontSize: 18, fontFamily: 'SpaceMono'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: isSelected ? 150 : 80,
                      height: isSelected ? 150 : 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 5,
                        ),
                        image: DecorationImage(
                          image: AssetImage(avatars[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(avatars.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedIndex == index
                          ? Colors.blue
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Votre nom',
                  style: TextStyle(fontFamily: 'SpaceMono', fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () async {
                      final selectedAvatar = avatars[_selectedIndex];
                      final name = _nameController.text.trim();
                      await _saveLogin(name, selectedAvatar, 'user');
                      Navigator.of(context).push(
                        PageAnimationTransition(
                          page: Bottombar(),
                          pageAnimationType: RightToLeftTransition(),
                        ),
                      );
                    }
                        : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? const Color(0xFF7088FF) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Terminer',
                    style: TextStyle(
                      fontFamily: 'SpaceMono',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}