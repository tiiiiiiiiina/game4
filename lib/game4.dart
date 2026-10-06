import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'gameover.dart';

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
  static const int cols = 4;
  static const int maxMiss = 5;
  static const List<double> colX = [-0.75, -0.25, 0.25, 0.75];

  late int basketCol;
  late bool movingRight;
  late int itemCol;
  late double itemY;
  late double itemVy;
  late double gravity;
  late int score;
  late int miss;
  late bool isGameOver;

  late Timer timer;
  final Random rand = Random();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    basketCol = 1; // 中央カラム（少し左寄り）
    movingRight = true;
    itemCol = rand.nextInt(cols);
    itemY = 0.0;
    itemVy = 0.0;
    gravity = 0.8;
    score = 0;
    miss = 0; // ミスの回数
    isGameOver = false; // ゲームオーバーかどうか
    timer = Timer.periodic(const Duration(milliseconds: 16), _update);
  }

  void _restartGame() {
    timer.cancel();
    _startNewGame();
    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _update(Timer t) {
    if (isGameOver) return;

    setState(() {
      const dt = 0.016;
      itemVy += gravity * dt;
      itemY += itemVy * dt;
      if (itemY >= 1.0) {
        final caught = (itemCol == basketCol);
        _resetItem(caught);
      }
    });
  }

  void _resetItem(bool caught) {
    if (caught) {
      score++;
      gravity = min(gravity + 0.1, 2.0); // 少しずつ重力アップ
    } else {
      miss++;
      if (miss >= maxMiss) {
        _gameOver();
        return;
      }
    }
    // 次のりんごを一番上から落とす
    itemY = 0.0;
    itemVy = 0.0;
    itemCol = rand.nextInt(cols);
  }

  void _gameOver() {
    isGameOver = true;
    timer.cancel();
  }

  void _onTap() {
    if (isGameOver) return;

    setState(() {
      // 0 ↔ 3 を往復
      if (movingRight) {
        if (basketCol < cols - 1) {
          basketCol++;
        } else {
          movingRight = false;
          basketCol--;
        }
      } else {
        if (basketCol > 0) {
          basketCol--;
        } else {
          movingRight = true;
          basketCol++;
        }
      }
    });
  }

  // レベル1からスタートして5点ごとにレベルアップ
  int get level {
    return 1 + (score ~/ 5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🌰 収穫ゲーム 🌰',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('スコア：$score  ミス：$miss / $maxMiss'),
                  Text('レベル：$level  重力：${gravity.toStringAsFixed(2)}'),
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
                        // 落ちてくるリンゴ（アニメーション）
                        Align(
                          alignment: Alignment(
                            colX[itemCol], // 左右位置
                            -0.8 + itemY * 1.4, // 上から落下
                          ),
                          child: const Text(
                            '🌰',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        // カゴ
                        Align(
                          alignment: Alignment(
                            colX[basketCol], // 左右位置
                            0.7, // 下側
                          ),
                          child: const Text(
                            '🐿️',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isGameOver)
              Positioned.fill(
                child: GameOverOverlay(score: score, onRestart: _restartGame),
              ),
          ],
        ),
      ),
    );
  }
}
