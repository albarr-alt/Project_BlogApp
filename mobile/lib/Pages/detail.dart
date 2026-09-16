import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final Map post;

  // Palet Warna Babble Editorial
  static const Color paper = Color(0xffFBFAF5);
  static const Color paperDim = Color(0xffF1EFE6);
  static const Color ink = Color(0xff1A1B18);
  static const Color inkSoft = Color(0xff4A4941);
  static const Color meta = Color(0xff8C8676);
  static const Color line = Color(0xffE6E3D6);
  static const Color accent = Color(0xff3F5D4E);

  const DetailPage({super.key, required this.post});

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return 'Baru saja';
    try {
      final date = DateTime.parse(dateStr.toString());
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = post['title'] ?? 'Tanpa Judul';
    final content = post['content'] ?? 'Tanpa isi';
    final category = (post['category'] ?? 'ARTIKEL').toString().toUpperCase();
    final author = post['username'] ?? post['author'] ?? 'Penulis';
    final imageUrl = post['imageUrl'];
    final hasImage = imageUrl != null && imageUrl.toString().trim().isNotEmpty;

    // Perkiraan waktu baca (200 kata per menit)
    final wordCount = content.toString().split(' ').length;
    final readTimeMinutes = (wordCount / 180).ceil().clamp(1, 60);

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        backgroundColor: paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: ink,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: line, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Judul Artikel (GoogleFonts Newsreader)
            Text(
              title,
              style: GoogleFonts.newsreader(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: ink,
                height: 1.26,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 18),

            // Info Penulis & Tanggal
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: accent,
                  child: Text(
                    author.toString().isNotEmpty
                        ? author.toString()[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          _formatDate(post['createdAt']),
                          style: const TextStyle(fontSize: 12, color: meta),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: meta,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '$readTimeMinutes mnt baca',
                          style: const TextStyle(fontSize: 12, color: meta),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 22),
            const Divider(color: line, height: 1),
            const SizedBox(height: 22),

            // Gambar Sampul (Jika Ada)
            if (hasImage) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl.toString(),
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Isi Konten Artikel (GoogleFonts Newsreader)
            Text(
              content,
              style: GoogleFonts.newsreader(
                fontSize: 18.5,
                height: 1.75,
                color: inkSoft,
                letterSpacing: 0.1,
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
