import 'package:flutter/material.dart';

import '../services/tvmaze_service.dart';
import '../widgets/show_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onOpenDetail});

  final ValueChanged<int> onOpenDetail;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TvMazeService _service = TvMazeService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _showsFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _showsFuture = _service.fetchShows();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Temukan tontonan',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB7F36B),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.live_tv_rounded,
                            color: Color(0xFF12160D)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Jelajahi serial TV dari katalog TVMaze.',
                      style: TextStyle(color: Colors.white.withValues(alpha: .6))),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari judul serial...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Daftar Shows',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _showsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(
                    message: 'Data belum dapat dimuat. Periksa koneksi internet.',
                    onRetry: () => setState(
                        () => _showsFuture = _service.fetchShows()),
                  ),
                );
              }

              final shows = snapshot.data ?? <Map<String, dynamic>>[];
              final filtered = shows.where((show) {
                final name = (show['name'] ?? '').toString().toLowerCase();
                return name.contains(_query);
              }).toList();

              if (filtered.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Tidak ada show yang ditemukan.')),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                sliver: SliverGrid.builder(
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .66,
                  ),
                  itemBuilder: (context, index) {
                    final show = filtered[index];
                    final id = (show['id'] as num?)?.toInt();
                    return ShowCard(
                      show: show,
                      onTap: id == null ? () {} : () => widget.onOpenDetail(id),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 42, color: Colors.white54),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
