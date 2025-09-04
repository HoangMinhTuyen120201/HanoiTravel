import 'package:flutter/material.dart';

import '../utils/locale_text.dart';
import 'splash_screen.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.85;
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/bannerHN.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  appTexts['vi']!['select_language']!,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LangButton(
                      width: buttonWidth,
                      asset: 'assets/flagVN.png',
                      viText: appTexts['vi']!['vietnamese']!,
                      enText: appTexts['en']!['vietnamese']!,
                      backgroundColor: Colors.white,
                      borderColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SplashScreen(lang: 'vi'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _LangButton(
                      width: buttonWidth,
                      asset: 'assets/flagEN.png',
                      viText: appTexts['vi']!['english']!,
                      enText: appTexts['en']!['english']!,
                      backgroundColor: Colors.white,
                      borderColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SplashScreen(lang: 'en'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final double width;
  final String asset;
  final String viText;
  final String enText;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;
  const _LangButton({
    required this.width,
    required this.asset,
    required this.viText,
    required this.enText,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 90,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                  child: Image.asset(asset, width: 40, height: 40),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      viText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      enText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
