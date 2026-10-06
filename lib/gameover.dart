import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // うっすら暗くする
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'スコア：$score',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRestart,
                child: const Text('🔁 もう一度'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}