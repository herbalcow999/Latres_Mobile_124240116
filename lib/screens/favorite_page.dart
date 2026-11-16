import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/show_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key, required this.onOpenDetail});

  final ValueChanged<int> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<String>('favorites');

    return SafeArea(
      child: ValueListenableBuilder<Box<String>>(
        valueListenable: box.listenable(),
        builder: (context, favorites, _) {
          final shows = favorites.values.map((value) {
            return Map<String, dynamic>.from(jsonDecode(value) as Map);
          }).toList();

          return CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 18),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Favorit',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900)),
                      SizedBox(height: 6),
                      Text('Kumpulan serial yang kamu simpan.',
                          style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                ),
              ),
              if (shows.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite_border_rounded,
                              size: 56, color: Colors.white38),
                          SizedBox(height: 14),
                          Text('Belum ada favorit',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('Tambahkan show melalui tombol hati di halaman detail.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid.builder(
                    itemCount: shows.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: .66,
                    ),
                    itemBuilder: (context, index) {
                      final show = shows[index];
                      final id = (show['id'] as num?)?.toInt();
                      return ShowCard(
                        show: show,
                        onTap: id == null ? () {} : () => onOpenDetail(id),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
