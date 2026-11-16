import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/tvmaze_service.dart';
import '../utils/show_helpers.dart';

class ShowDetailPage extends StatefulWidget {
  const ShowDetailPage({super.key, required this.showId});

  final int showId;

  @override
  State<ShowDetailPage> createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends State<ShowDetailPage> {
  final TvMazeService _service = TvMazeService();
  late Future<Map<String, dynamic>> _detailFuture;
  late Box<String> _favoritesBox;

  @override
  void initState() {
    super.initState();
    _favoritesBox = Hive.box<String>('favorites');
    _detailFuture = _service.fetchShowDetail(widget.showId);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  void _toggleFavorite(Map<String, dynamic> show) {
    final key = widget.showId.toString();
    if (_favoritesBox.containsKey(key)) {
      _favoritesBox.delete(key);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dihapus dari favorit.')),
      );
    } else {
      _favoritesBox.put(key, jsonEncode(favoritePayload(show)));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ditambahkan ke favorit.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Show')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 42),
                    const SizedBox(height: 12),
                    const Text('Detail show gagal dimuat.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => setState(() => _detailFuture =
                          _service.fetchShowDetail(widget.showId)),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final show = snapshot.data!;
          final imageUrl = showImageUrl(show);
          final genres = showGenres(show);
          final summary = cleanSummary(show['summary']);
          final rating = showRating(show);
          final name = (show['name'] ?? 'Tanpa judul').toString();

          return ValueListenableBuilder<Box<String>>(
            valueListenable: _favoritesBox.listenable(),
            builder: (context, box, _) {
              final isFavorite = box.containsKey(widget.showId.toString());
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: imageUrl.isEmpty
                            ? const ColoredBox(
                                color: Color(0xFF292F3B),
                                child: Icon(Icons.movie_outlined, size: 56),
                              )
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const ColoredBox(
                                  color: Color(0xFF292F3B),
                                  child: Icon(Icons.broken_image_outlined,
                                      size: 56),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(name,
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w900)),
                        ),
                        IconButton.filledTonal(
                          tooltip: isFavorite
                              ? 'Hapus dari favorit'
                              : 'Tambah ke favorit',
                          onPressed: () => _toggleFavorite(show),
                          icon: Icon(isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFD166)),
                        const SizedBox(width: 6),
                        Text(rating,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        if ((show['premiered'] ?? '').toString().length >= 4)
                          Text((show['premiered']).toString().substring(0, 4),
                              style: const TextStyle(color: Colors.white60)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Genre',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    if (genres.isEmpty)
                      const Text('Genre tidak tersedia.',
                          style: TextStyle(color: Colors.white60))
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: genres
                            .map((genre) => Chip(
                                  label: Text(genre),
                                  backgroundColor: const Color(0xFF242A35),
                                  side: BorderSide.none,
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 20),
                    const Text('Overview',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(summary,
                        style: const TextStyle(
                            color: Colors.white70, height: 1.55)),
                    const SizedBox(height: 20),
                    _InfoRow(label: 'Status', value: '${show['status'] ?? '-'}'),
                    _InfoRow(
                        label: 'Bahasa', value: '${show['language'] ?? '-'}'),
                    _InfoRow(
                        label: 'Durasi',
                        value: show['runtime'] == null
                            ? '-'
                            : '${show['runtime']} menit'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          SizedBox(
            width: 86,
            child: Text(label, style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
