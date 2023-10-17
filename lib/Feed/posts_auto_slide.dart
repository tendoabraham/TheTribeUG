import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlideScrollView extends StatefulWidget {
  final List<Map<String, String?>> news;

  AutoSlideScrollView({required this.news});

  @override
  _AutoSlideScrollViewState createState() => _AutoSlideScrollViewState();
}

class _AutoSlideScrollViewState extends State<AutoSlideScrollView> {
  late PageController _pageController;
  int _currentPage = 0;
  final _pageDuration = Duration(seconds: 5); // Adjust the slide duration as needed
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.9,);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(_pageDuration, (Timer timer) {
      if (_currentPage < widget.news.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _openVideoPlayer(String videoUrl) {
    // You can navigate to a new page with the video player widget here
    // For simplicity, let's just print the URL for now
    print("Opening video player for URL: $videoUrl");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust the height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.news.length,
        itemBuilder: (context, index) {
          final post = widget.news[index];
          return GestureDetector(
            onTap: () {
              _openVideoPlayer(post['videoUrl']!);
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              width: 310, // Adjust the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Add curved borders
                border: Border.all(color: Colors.red, width: 2), // Red border
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // Clip content
                child: Image.asset(
                  post['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
