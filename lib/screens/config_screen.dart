import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  String _difficulty = 'Normal';
  final List<String> _difficulties = ['Easy', 'Normal', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Difficulty'),
            DropdownButton<String>(
              value: _difficulty,
              items: _difficulties
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _difficulty = value);
              },
            ),
            const SizedBox(height: 24),
            const Text('Resolution (static for now)'),
            const Text('800 x 600'),
          ],
        ),
      ),
    );
  }
}

