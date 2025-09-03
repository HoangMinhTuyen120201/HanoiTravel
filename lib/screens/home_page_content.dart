import 'package:flutter/material.dart';

import '../utils/locale_text.dart';

class HomePageContent extends StatelessWidget {
  final String lang;
  const HomePageContent({super.key, required this.lang});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        appTexts[lang]!['welcome']!,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
