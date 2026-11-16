import 'package:flutter/material.dart';

import 'favorite_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'show_detail_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.username, required this.onLogout});

  final String username;
  final Future<void> Function() onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _openDetail(int showId) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ShowDetailPage(showId: showId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(onOpenDetail: _openDetail),
      FavoritePage(onOpenDetail: _openDetail),
      ProfilePage(username: widget.username, onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF171A22),
        selectedItemColor: const Color(0xFFB7F36B),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: 'Favorit'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
