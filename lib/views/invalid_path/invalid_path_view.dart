import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InvalidPathView extends StatelessWidget {
  const InvalidPathView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Invalid path'),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('Go to home'),
            ),
          ],
        ),
      ),
    );
  }
}
