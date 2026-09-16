import 'dart:async';
import 'package:flutter/material.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final String Function(dynamic)? formatTime;
  final ValueChanged<Map<String, dynamic>>? onTapPost;

  const FeaturedCarousel({
    super.key,
    required this.posts,
    this.formatTime,
    this.onTapPost,
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  static const Color paperDim = Color(0xffF1EFE6);
  static const Color meta = Color(0xff8C8676);
  static const Color accent = Color(0xff3F5D4E);
  static const Color accentSoft = Color(0xffE7EEE9);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant FeaturedCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.posts.length != widget.posts.length) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.posts.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients && widget.posts.length > 1) {
          _currentIndex = (_currentIndex + 1) % widget.posts.length;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      // ScrollConfiguration memastikan tidak ada panah scrollbar desktop / web
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          overscroll: false,
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.posts.length,
          onPageChanged: (index) {
            _currentIndex = index;
          },
          itemBuilder: (context, index) {
            final item = widget.posts[index];
            final imageUrl = item['imageUrl'];
            final hasImage =
                imageUrl != null && imageUrl.toString().trim().isNotEmpty;

            return GestureDetector(
              onTap: () => widget.onTapPost?.call(item),
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: paperDim,
                ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar Sampul (Tanpa tombol arrow/panah apa pun)
                    if (hasImage)
                      Image.network(
                        imageUrl.toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: paperDim,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: meta,
                          ),
                        ),
                      )
                    else
                      Container(
                        color: accentSoft,
                        child: Center(
                          child: Icon(
                            Icons.auto_stories_outlined,
                            size: 48,
                            color: accent.withValues(alpha: 0.6),
                          ),
                        ),
                      ),

                    // Gradient Gelap di Bagian Bawah
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.2, 1.0],
                          colors: [
                            Colors.transparent,
                            const Color(0xff0f100d).withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),

                    // Teks Judul & Tanggal
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.formatTime != null) ...[
                            Text(
                              widget.formatTime!(item['createdAt']),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xffD9D7CC),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                          ],
                          Text(
                            item['title'] ?? 'Tanpa Judul',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}
