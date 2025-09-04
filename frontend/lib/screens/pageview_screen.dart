import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/locale_text.dart';
import '../widgets/screen_content.dart';

class PageViewScreen extends StatefulWidget {
  final String lang;
  const PageViewScreen({super.key, required this.lang});
  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              ScreenContent(
                color: Colors.white,
                text: appTexts[lang]!['welcome']! + '\n Hà Nội',
                svgPath: 'assets/1.svg',
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Happy Memories',
                ),
                svgWidth: 150,
                svgHeight: 150,
                lang: lang,
              ),
              ScreenContent(
                color: Colors.white,
                text: lang == 'vi'
                    ? 'Với những gợi ý địa điểm tham quan lý tưởng'
                    : 'With ideal sightseeing suggestions',
                svgPath: 'assets/2.svg',
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Happy Memories',
                ),
                svgWidth: 100,
                svgHeight: 100,
                lang: lang,
              ),
              ScreenContent(
                color: Colors.white,
                text: lang == 'vi' ? 'Những tính năng hay' : 'Useful features',
                svgPath: 'assets/3.svg',
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Happy Memories',
                ),
                svgWidth: 150,
                svgHeight: 150,
                lang: lang,
              ),
              ScreenContent(
                color: Colors.white,
                text: appTexts[lang]!['start']!,
                svgPath: 'assets/4.svg',
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                  fontFamily: 'Happy Memories',
                ),
                showButton: true,
                svgWidth: 150,
                svgHeight: 150,
                lang: lang,
              ),
            ],
          ),
          Positioned(
            bottom: 40.0,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: const WormEffect(
                  dotColor: Colors.red,
                  activeDotColor: Colors.yellowAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
