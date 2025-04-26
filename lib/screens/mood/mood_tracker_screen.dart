import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/assets_manager.dart';
import '../../providers/theme_provider.dart';
import 'mood_log_screen.dart';
import 'mood_history_screen.dart';

// Floating Emoji Widget (unchanged)
class FloatingEmoji extends StatefulWidget {
  final String emoji;
  final double startX;
  final double size;
  final int speed;

  const FloatingEmoji({
    Key? key,
    required this.emoji,
    required this.startX,
    required this.size,
    required this.speed,
  }) : super(key: key);

  @override
  State<FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.speed),
    )..repeat();

    _animation = Tween<double>(begin: 1.2, end: -0.2).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.startX * screenWidth,
          top: MediaQuery.of(context).size.height * _animation.value,
          child: Text(
            widget.emoji,
            style: TextStyle(fontSize: widget.size),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Mood Tracker Screen
class MoodTrackerScreen extends StatelessWidget {
  MoodTrackerScreen({Key? key}) : super(key: key);

  final List<String> emojis = ['😊', '😐', '😢', '😡', '😴'];
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoApp, height: 36),
        ),
        title: Text(
          'Mood Tracker',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        leadingWidth: 50,
      ),
      body: Stack(
        children: [
          // Dynamic Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.black, Colors.grey.shade900]
                    : [Colors.blue.shade300, Colors.blue.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Floating Emojis
          ...List.generate(20, (index) {
            return FloatingEmoji(
              emoji: emojis[random.nextInt(emojis.length)],
              startX: random.nextDouble(),
              size: random.nextDouble() * 16 + 24,
              speed: random.nextInt(10) + 14,
            );
          }),

          // Centered Buttons
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.85),
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodLogScreen()),
                    );
                  },
                  child: const Text("Log your Mood",
                      style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.85),
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodHistoryScreen()),
                    );
                  },
                  child: const Text("View Mood History",
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
