import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../widget/custom_bottom_nav.dart';
import '../widget/featured_carousel.dart';
import '../widget/post_card_tile.dart';
import 'create.dart';
import 'detail.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? user;

  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Palet Warna Editorial Babble
  static const Color paper = Color(0xffFBFAF5);
  static const Color paperDim = Color(0xffF1EFE6);
  static const Color ink = Color(0xff1A1B18);
  static const Color inkSoft = Color(0xff57564D);
  static const Color meta = Color(0xff8C8676);
  static const Color line = Color(0xffE6E3D6);
  static const Color accent = Color(0xff3F5D4E);

  Map<String, dynamic>? currentUser;
  List<Map<String, dynamic>> _posts = [];
  bool _isLoadingPosts = true;
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPosts {
    if (_searchQuery.trim().isEmpty) {
      return _posts;
    }
    final q = _searchQuery.toLowerCase().trim();
    return _posts.where((post) {
      final title = (post['title'] ?? '').toString().toLowerCase();
      final content = (post['content'] ?? '').toString().toLowerCase();
      final author = (post['username'] ?? post['author'] ?? '').toString().toLowerCase();
      return title.contains(q) || content.contains(q) || author.contains(q);
    }).toList();
  }

  Future<void> _loadUser() async {
    if (widget.user != null) {
      setState(() => currentUser = widget.user);
    } else {
      final user = await AuthService.getUser();
      setState(() => currentUser = user);
    }
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoadingPosts = true);
    final posts = await PostService.getPosts();
    if (!mounted) return;
    setState(() {
      _posts = posts;
      _isLoadingPosts = false;
    });
  }

  void _showProfileModal() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
    _loadPosts();
  }

  void _navigateToCreatePost() async {
    final published = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostPage()),
    );
    if (published == true) {
      _loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = currentUser?['username'] ?? 'Pengguna';

    return Scaffold(
      backgroundColor: paper,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Konten Halaman yang Dapat Di-scroll
            RefreshIndicator(
              color: accent,
              onRefresh: _loadPosts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. App Bar dengan Brand "Babble"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ink,
                                letterSpacing: -0.4,
                              ),
                              children: [
                                TextSpan(text: 'Bab'),
                                TextSpan(
                                  text: 'ble',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _showProfileModal,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: accent,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  username.isNotEmpty
                                      ? username[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2. Greeting Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $username',
                            style: const TextStyle(
                              fontSize: 13,
                              color: meta,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Apa yang ingin kamu baca hari ini?',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: ink,
                              height: 1.28,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 3. Search Bar Interaktif
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: paperDim,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _searchQuery.isNotEmpty ? accent : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 20, color: meta),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ink,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Cari tulisan atau penulis...',
                                  hintStyle: TextStyle(
                                    fontSize: 13.5,
                                    color: meta,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.close_rounded, size: 18, color: meta),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // 4. Featured Carousel (Hanya muncul jika tidak sedang mencari)
                    if (_searchQuery.isEmpty) ...[
                      const SizedBox(height: 28),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'PILIHAN HARI INI',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: inkSoft,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_isLoadingPosts)
                        const SizedBox(
                          height: 175,
                          child: Center(
                            child: CircularProgressIndicator(color: accent),
                          ),
                        )
                      else if (_posts.isEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: paperDim,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: line),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.menu_book_rounded,
                                size: 40,
                                color: accent,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Belum Ada Tulisan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Jadilah yang pertama menulis cerita atau artikel!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: meta),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: _navigateToCreatePost,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Tulis Artikel Sekarang'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        FeaturedCarousel(
                          posts: _posts,
                          onTapPost: (item) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(post: item),
                              ),
                            );
                          },
                        ),
                    ],

                    const SizedBox(height: 28),

                    // 5. Section Label (Dinamis sesuai status pencarian)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'HASIL PENCARIAN (${_filteredPosts.length})'
                            : 'TERBARU',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: inkSoft,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 6. Feed List (Hasil pencarian atau postingan asli)
                    if (_isLoadingPosts)
                      const SizedBox(height: 100)
                    else if (_filteredPosts.isEmpty && _searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 36,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 46,
                                color: meta,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Tidak Ada Tulisan Ditemukan',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tidak ditemukan tulisan yang cocok dengan "$_searchQuery". Coba kata kunci lain.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13, color: meta),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_posts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Text(
                          'Feed masih kosong. Postingan barumu akan muncul di sini.',
                          style: TextStyle(fontSize: 13, color: meta),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredPosts.length,
                          separatorBuilder: (context, index) => const Divider(
                            color: line,
                            height: 1,
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            final postItem = _filteredPosts[index];
                            return PostCardTile(
                              post: postItem,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(post: postItem),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 8. Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNav(
                currentIndex: _currentNavIndex,
                onTapNav: (index) {
                  setState(() => _currentNavIndex = index);
                },
                onAddPost: _navigateToCreatePost,
                onOpenProfile: _showProfileModal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
