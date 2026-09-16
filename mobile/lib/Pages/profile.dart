import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/post_service.dart';
import '../utils/app_colors.dart';
import '../widget/user_post_tile.dart';
import 'detail.dart';
import 'edit.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;
  List<Map<String, dynamic>> _userPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    final user = await AuthService.getUser();
    List<Map<String, dynamic>> posts = [];

    if (user != null && user['id'] != null) {
      final userId = user['id'] is int ? user['id'] : int.tryParse(user['id'].toString()) ?? 0;
      posts = await UserService.getUserPosts(userId);
    }

    if (mounted) {
      setState(() {
        _user = user;
        _userPosts = posts;
        _isLoading = false;
      });
    }
  }

  void _confirmDelete(Map<String, dynamic> post) {
    final postId = post['id'] is int ? post['id'] : int.tryParse(post['id'].toString()) ?? 0;
    final title = post['title'] ?? 'postingan ini';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Tulisan?',
          style: GoogleFonts.newsreader(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "$title"? Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontSize: 14, color: AppColors.inkLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.inkMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await PostService.deletePost(postId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message'] ?? 'Postingan dihapus'),
                    backgroundColor: result['success'] == true ? AppColors.accent : Colors.redAccent,
                  ),
                );
                if (result['success'] == true) {
                  _loadProfileData();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _user?['username'] ?? 'Penulis Babble';
    final email = _user?['email'] ?? 'user@babble.id';
    final role = _user?['role'] ?? 'Member';

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil Saya',
          style: GoogleFonts.newsreader(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            tooltip: 'Keluar',
            onPressed: _handleLogout,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.border, height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : RefreshIndicator(
              color: AppColors.accent,
              onRefresh: _loadProfileData,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  // Profil Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                          child: Text(
                            username.isNotEmpty ? username[0].toUpperCase() : 'B',
                            style: GoogleFonts.newsreader(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: GoogleFonts.newsreader(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.paperDim,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  role.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Header Tulisan Saya
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tulisan Saya',
                        style: GoogleFonts.newsreader(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_userPosts.length} Artikel',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Daftar Tulisan Milik User
                  if (_userPosts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum Ada Tulisan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kamu belum menerbitkan artikel apapun. Mulai tulis ceritamu sekarang!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._userPosts.map(
                      (post) => UserPostTile(
                        post: post,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(post: post),
                            ),
                          );
                        },
                        onEdit: () async {
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPostPage(post: post),
                            ),
                          );
                          if (updated == true) {
                            _loadProfileData();
                          }
                        },
                        onDelete: () => _confirmDelete(post),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
