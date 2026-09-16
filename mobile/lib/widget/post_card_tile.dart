import 'package:flutter/material.dart';

class PostCardTile extends StatelessWidget {
  final Map<String, dynamic> post;
  final String? timeText;

  static const Color paperDim = Color(0xffF1EFE6);
  static const Color ink = Color(0xff1A1B18);
  static const Color inkSoft = Color(0xff57564D);
  static const Color meta = Color(0xff8C8676);

  final VoidCallback? onTap;

  const PostCardTile({
    super.key,
    required this.post,
    this.timeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = post['imageUrl'];
    final hasImage = imageUrl != null && imageUrl.toString().trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 78,
              height: 78,
              color: paperDim,
              child: hasImage
                  ? Image.network(
                      imageUrl.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_outlined,
                        color: meta,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'tanpa\ngambar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: meta,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),

          // Teks Info Postingan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (timeText != null && timeText!.isNotEmpty) ...[
                  Text(
                    timeText!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: meta,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Text(
                  post['title'] ?? 'Tanpa Judul',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ink,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  post['content'] ?? '',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: inkSoft,
                    height: 1.4,
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
  );
}
}
