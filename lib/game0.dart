import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CatchGamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CatchGamePage extends StatefulWidget {
  const CatchGamePage({super.key});
  @override
  State<CatchGamePage> createState() => _CatchGamePageState();
}

class _CatchGamePageState extends State<CatchGamePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🍎 収穫ゲーム 🍎',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Container(
                width: 220,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // 落ちるリンゴ
                    const Align(
                      alignment: Alignment(
                        0.0, // 中央
                        -0.8, // 上側
                      ),
                      child: Text('🍎', style: TextStyle(fontSize: 32)),
                    ),
                    // カゴ
                    const Align(
                      alignment: Alignment(
                        0.0, // 中央
                        0.7, // 下側
                      ),
                      child: Text('🧺', style: TextStyle(fontSize: 32)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
