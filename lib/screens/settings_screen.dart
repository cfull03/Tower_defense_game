import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Music Volume'),
            Slider(
              value: _volume,
              onChanged: (value) => setState(() => _volume = value),
              min: 0,
              max: 1,
            ),
            Text('Volume: ${(_volume * 100).round()}%'),
          ],
        ),
      ),
    );
  }
}
