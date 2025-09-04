import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/locale_text.dart';
import 'pageview_screen.dart';

class SplashScreen extends StatefulWidget {
  final String lang;
  const SplashScreen({super.key, required this.lang});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageViewScreen(lang: widget.lang),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth,
              child: AspectRatio(
                aspectRatio: 12 / 9,
                child: SvgPicture.asset('assets/2.svg'),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              appTexts[widget.lang]!['welcome']!,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                color: Color(0xFFDC3C3C),
                fontSize: 35,
                fontFamily: 'Happy Memories',
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.red,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(color: Colors.red),
          ],
        ),
      ),
    );
  }
}
