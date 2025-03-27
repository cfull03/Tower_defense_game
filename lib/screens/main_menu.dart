import 'package:flutter/material.dart';
import 'game_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tower Defense Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start Game Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 20),
            
            // Settings Button (Placeholder for future use)
            ElevatedButton(
              onPressed: () {
                // TODO: Add settings screen or functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              },
              child: const Text('Settings'),
            ),
            
            const SizedBox(height: 20),

            // Exit Button to Quit the Game
            ElevatedButton(
              onPressed: () {
                // Exit the app
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
