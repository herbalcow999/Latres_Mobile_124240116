import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.username,
    required this.onLogout,
  });

  final String username;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
        children: [
          const Text('Profil',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          Center(
            child: Container(
              height: 104,
              width: 104,
              decoration: BoxDecoration(
                color: const Color(0xFFB7F36B),
                borderRadius: BorderRadius.circular(34),
              ),
              child: const Icon(Icons.person_rounded,
                  color: Color(0xFF12160D), size: 58),
            ),
          ),
          const SizedBox(height: 14),
          Text(username,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          const Text('Mahasiswa Sistem Informasi',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF191D27),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF2A303D)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kesan dan Pesan Praktikum',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                SizedBox(height: 10),
                Text(
                  'Kesan: Praktikum Mobile ini sangatlah asik dan tidaklah rumit sama sekali. gampang dimengerti dan tidak membuat ngantuk. ku kasih nilai 10/10 bukan propaganda yahudi.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                SizedBox(height: 10),
                Text(
                  'Pesan: Semoga Praktikum ini bakal lebih baik lagi kedepannya. dan juga lebih asik lagi untuk adek-adek tingkat. semangat kakak-kakak aslab!!',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Apakah kamu yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Batal'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (shouldLogout == true) await onLogout();
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF8585),
                side: const BorderSide(color: Color(0xFF8E4545)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
