import 'package:flutter/material.dart';
import '../services/post_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // Palet Warna Marginal
  static const Color paper = Color(0xffFBFAF5);
  static const Color paperDim = Color(0xffF1EFE6);
  static const Color ink = Color(0xff1A1B18);
  static const Color inkSoft = Color(0xff57564D);
  static const Color meta = Color(0xff8C8676);
  static const Color line = Color(0xffE6E3D6);
  static const Color accent = Color(0xff3F5D4E);

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final imageUrl = _imageController.text.trim();

    if (title.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul minimal 3 karakter'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (content.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi tulisan minimal 10 karakter'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await PostService.createPost(
      title: title,
      content: content,
      imagePath: imageUrl.isNotEmpty ? imageUrl : null,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Berhasil menerbitkan tulisan!'),
          backgroundColor: accent,
        ),
      );
      // Kembali ke beranda dan kirim true agar beranda otomatis me-refresh daftar postingan
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal memposting tulisan'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        backgroundColor: paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tulis Artikel Baru',
          style: TextStyle(
            color: ink,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Terbitkan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: line, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input URL Gambar Sampul
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: paperDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _imageController,
                style: const TextStyle(fontSize: 13.5, color: ink),
                decoration: const InputDecoration(
                  icon: Icon(Icons.image_outlined, size: 20, color: meta),
                  hintText: 'Tautan URL Gambar Sampul (opsional)',
                  hintStyle: TextStyle(color: meta, fontSize: 13.5),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Input Judul
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ink,
                height: 1.3,
              ),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Judul Tulisan...',
                hintStyle: TextStyle(
                  color: meta,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: line, height: 1),
            const SizedBox(height: 16),

            // Input Konten / Isi
            TextField(
              controller: _contentController,
              style: const TextStyle(
                fontSize: 15.5,
                color: inkSoft,
                height: 1.6,
              ),
              maxLines: null,
              minLines: 12,
              decoration: const InputDecoration(
                hintText: 'Mulai ketikkan cerita atau idemu di sini...',
                hintStyle: TextStyle(
                  color: meta,
                  fontSize: 15.5,
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
