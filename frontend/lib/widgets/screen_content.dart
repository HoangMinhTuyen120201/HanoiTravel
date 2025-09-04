import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'animated_button.dart';

class ScreenContent extends StatelessWidget {
  final Color color;
  final String text;
  final String svgPath;
  final TextStyle textStyle;
  final bool showButton;
  final double svgWidth;
  final double svgHeight;
  final String lang;

  const ScreenContent({
    required this.color,
    required this.text,
    required this.svgPath,
    required this.textStyle,
    this.showButton = false,
    required this.svgWidth,
    required this.svgHeight,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgPath, width: svgWidth, height: svgHeight),
          const SizedBox(height: 20),
          Text(text, style: textStyle, textAlign: TextAlign.center),
          if (showButton)
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: AnimatedButton(lang: lang),
            ),
        ],
      ),
    );
  }
}
