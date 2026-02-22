import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChildScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const ChildScaffold({
    super.key,
    required this.body,
    this.title = 'EaseFlow',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade900,

      // ✅ Simple top bar (no complex drawer for kids)
      appBar: AppBar(
        backgroundColor: Colors.teal.shade800,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        // ✅ logout icon (small but available)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: SafeArea(child: body),
    );
  }
}