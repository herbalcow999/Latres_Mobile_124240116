import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'main_shell.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<String?> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _readSession();
  }

  Future<String?> _readSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void _onLogin(String username) {
    setState(() {
      _sessionFuture = Future<String?>.value(username);
    });
  }

  Future<void> _onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    if (!mounted) return;
    setState(() {
      _sessionFuture = Future<String?>.value(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final username = snapshot.data;
        if (username == null || username.isEmpty) {
          return LoginPage(onLogin: _onLogin);
        }
        return MainShell(username: username, onLogout: _onLogout);
      },
    );
  }
}
