import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'home_page_content.dart';

class MainScreen extends StatefulWidget {
  final String lang;
  const MainScreen({super.key, required this.lang});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    return Scaffold(
      body: Center(
        child: _selectedIndex == 1 ? HomePageContent(lang: lang) : Container(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.red,
        items: const <Widget>[
          Icon(Icons.location_searching, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.favorite, size: 30),
        ],
        onTap: _onItemTapped,
        index: 1,
      ),
      backgroundColor: Colors.red,
    );
  }
}
