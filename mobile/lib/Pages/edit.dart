import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../utils/app_colors.dart';

class EditPostPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _imageController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post['title'] ?? '');
    _contentController = TextEditingController(text: widget.post['content'] ?? '');
    _imageController = TextEditingController(
      text: widget.post['imageUrl'] ?? widget.post['image_url'] ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitUpdate() async {
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

    final postId = widget.post['id'] is int
        ? widget.post['id']
        : int.tryParse(widget.post['id'].toString()) ?? 0;

    final result = await PostService.updatePost(
      id: postId,
      title: title,
      content: content,
      imagePath: imageUrl.isNotEmpty ? imageUrl : null,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Postingan berhasil diperbarui!'),
          backgroundColor: AppColors.accent,
        ),
      );
      // Kembali dan beritahu pemanggil bahwa perubahan berhasil disimpan
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal memperbarui postingan'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Tulisan',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
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
                      'Simpan',
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
          child: Divider(color: AppColors.border, height: 1),
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
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _imageController,
                style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
                decoration: const InputDecoration(
                  icon: Icon(Icons.image_outlined, size: 20, color: AppColors.inkMuted),
                  hintText: 'Tautan URL Gambar Sampul (opsional)',
                  hintStyle: TextStyle(color: AppColors.inkMuted, fontSize: 13.5),
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
                color: AppColors.ink,
                height: 1.3,
              ),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Judul Tulisan...',
                hintStyle: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 16),

            // Input Konten
            TextField(
              controller: _contentController,
              style: const TextStyle(
                fontSize: 15.5,
                color: AppColors.inkLight,
                height: 1.6,
              ),
              maxLines: null,
              minLines: 12,
              decoration: const InputDecoration(
                hintText: 'Perbarui isi tulisan di sini...',
                hintStyle: TextStyle(
                  color: AppColors.inkMuted,
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
