import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'config_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  void _exitApp(BuildContext context) {
    Navigator.of(context).maybePop(); // Exit for web or back out
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Start Game'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Settings'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Configuration'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfigScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Exit'),
              onPressed: () => _exitApp(context),
            ),
          ],
        ),
      ),
    );
  }
}
