import 'dart:async';

import 'package:flutter/material.dart';

import '../models/locations.dart';
import '../services/location_service.dart';
import '../utils/locale_text.dart';

class HomePageContent extends StatefulWidget {
  final String lang;
  const HomePageContent({super.key, required this.lang});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  List<Location> _featuredLocations = [];
  List<Location> _allLocations = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final List<Map<String, String>> _recommendedTours = [
    {
      'image': 'assets/location_hoangthanh.jpg',
      'title': 'Tour Hoàng Thành Cổ',
      'titleEn': 'Ancient Citadel Tour',
      'duration': '3 giờ',
      'durationEn': '3 hours',
      'price': '200.000đ',
      'priceEn': '200,000 VND',
    },
    {
      'image': 'assets/location_vanmieu.jpg',
      'title': 'Tour Văn Hóa Phố Cổ',
      'titleEn': 'Old Quarter Culture Tour',
      'duration': '4 giờ',
      'durationEn': '4 hours',
      'price': '350.000đ',
      'priceEn': '350,000 VND',
    },
    {
      'image': 'assets/location_chuamotcot.jpg',
      'title': 'Tour Tâm Linh Hà Nội',
      'titleEn': 'Hanoi Spiritual Tour',
      'duration': '2 giờ',
      'durationEn': '2 hours',
      'price': '150.000đ',
      'priceEn': '150,000 VND',
    },
    {
      'image': 'assets/location_baotanghanoi.png',
      'title': 'Tour Bảo Tàng Lịch Sử',
      'titleEn': 'Historical Museum Tour',
      'duration': '2.5 giờ',
      'durationEn': '2.5 hours',
      'price': '180.000đ',
      'priceEn': '180,000 VND',
    },
  ];

  final List<Map<String, String>> _travelTips = [
    {
      'image': 'assets/location_hoangthanh.jpg',
      'title': 'Những điều cần biết khi du lịch Hà Nội',
      'titleEn': 'Essential Tips for Visiting Hanoi',
      'subtitle': 'Chuẩn bị tốt nhất cho chuyến đi',
      'subtitleEn': 'Best preparation for your trip',
      'readTime': '5 phút đọc',
      'readTimeEn': '5 min read',
    },
    {
      'image': 'assets/location_vanmieu.jpg',
      'title': 'Ẩm thực đường phố Hà Nội không thể bỏ qua',
      'titleEn': 'Must-try Hanoi Street Food',
      'subtitle': 'Khám phá hương vị đặc trưng',
      'subtitleEn': 'Discover authentic flavors',
      'readTime': '7 phút đọc',
      'readTimeEn': '7 min read',
    },
    {
      'image': 'assets/location_chuamotcot.jpg',
      'title': 'Lịch trình 3 ngày khám phá Hà Nội',
      'titleEn': '3-Day Hanoi Itinerary',
      'subtitle': 'Tối ưu thời gian và chi phí',
      'subtitleEn': 'Optimize time and budget',
      'readTime': '10 phút đọc',
      'readTimeEn': '10 min read',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final allLocationsResult = await LocationService.getAllLocations();
      if (allLocationsResult['success']) {
        final allData = (allLocationsResult['data'] as List)
            .map((e) => Location.fromJson(e))
            .toList();
        setState(() {
          _allLocations = allData;
          _featuredLocations = allData
              .where((location) => location.isFeatured == true)
              .toList();
          if (_featuredLocations.isEmpty) {
            _featuredLocations = allData.toList();
          }
          _isLoading = false;
        });
        _startAutoSlide();
      } else {
        setState(() {
          _errorMessage = allLocationsResult['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = appTexts[widget.lang]!['error_loading']!;
        _isLoading = false;
      });
    }
  }

  void _startAutoSlide() {
    if (_featuredLocations.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_currentPage < _featuredLocations.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildSlideIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_featuredLocations.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.black : Colors.white,
          ),
        );
      }),
    );
  }

  Widget _buildFeaturedSlider() {
    if (_isLoading) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            semanticsLabel: appTexts[widget.lang]!['loading'],
          ),
        ),
      );
    }
    if (_errorMessage.isNotEmpty) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Center(
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_featuredLocations.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _featuredLocations.length,
            itemBuilder: (context, index) {
              final location = _featuredLocations[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        location.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          widget.lang == 'vi' ? location.name : location.nameEn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildSlideIndicator(),
      ],
    );
  }

  Widget _buildAllLocationsGrid() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appTexts[widget.lang]!['all_locations']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  appTexts[widget.lang]!['view_all']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        else if (_errorMessage.isNotEmpty)
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else if (_allLocations.isEmpty)
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                appTexts[widget.lang]!['no_locations']!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: _allLocations.length > 4 ? 4 : _allLocations.length,
              itemBuilder: (context, index) {
                final location = _allLocations[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          location.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 30,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Text(
                            widget.lang == 'vi'
                                ? location.name
                                : location.nameEn,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedTours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            appTexts[widget.lang]!['recommended_tours']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recommendedTours.length,
            itemBuilder: (context, index) {
              final tour = _recommendedTours[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Image.asset(
                              tour['image']!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.lang == 'vi'
                                      ? tour['duration']!
                                      : tour['durationEn']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.lang == 'vi'
                                    ? tour['title']!
                                    : tour['titleEn']!,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.lang == 'vi'
                                        ? tour['price']!
                                        : tour['priceEn']!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[400],
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTravelTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appTexts[widget.lang]!['travel_tips']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  appTexts[widget.lang]!['view_all']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _travelTips.length,
          itemBuilder: (context, index) {
            final tip = _travelTips[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(tip['image']!, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lang == 'vi'
                                  ? tip['title']!
                                  : tip['titleEn']!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lang == 'vi'
                                  ? tip['subtitle']!
                                  : tip['subtitleEn']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey[500],
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.lang == 'vi'
                                      ? tip['readTime']!
                                      : tip['readTimeEn']!,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  appTexts[widget.lang]!['explore']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildFeaturedSlider(),
              const SizedBox(height: 32),
              _buildAllLocationsGrid(),
              const SizedBox(height: 32),
              _buildRecommendedTours(),
              const SizedBox(height: 32),
              _buildTravelTips(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
