import 'package:flutter/material.dart';

import '../utils/show_helpers.dart';

class ShowCard extends StatelessWidget {
  const ShowCard({super.key, required this.show, required this.onTap});

  final Map<String, dynamic> show;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = showImageUrl(show);
    final rating = showRating(show);

    return Material(
      color: const Color(0xFF191D27),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox.expand(
                child: imageUrl.isEmpty
                    ? const ColoredBox(
                        color: Color(0xFF292F3B),
                        child: Icon(Icons.movie_outlined,
                            size: 42, color: Colors.white38),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0xFF292F3B),
                          child: Icon(Icons.broken_image_outlined,
                              size: 42, color: Colors.white38),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (show['name'] ?? 'Tanpa judul').toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 16, color: Color(0xFFFFD166)),
                      const SizedBox(width: 4),
                      Text(rating,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
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
