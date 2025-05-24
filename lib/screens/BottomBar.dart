import 'package:flutter/material.dart';
import 'package:geowhiz/screens/Settings.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../utils/TextStyles.dart';
import 'Home.dart';


class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Home(),
      Settings(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
            opacity: 0.3),
        iconSpace: 12.0,
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: smallTextBlack('Home'),
            backgroundColor: Colors.black,
            selectedColor: Colors.black,
            unSelectedColor: Colors.black,
            showBadge: false,
          ),
          BottomBarItem(
            icon: const Icon(Icons.info_rounded),
            title: smallTextBlack('Infos'),
            selectedColor: Colors.green,
            backgroundColor: Colors.black,
            unSelectedColor: Colors.black,
          )
        ],
        hasNotch: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
