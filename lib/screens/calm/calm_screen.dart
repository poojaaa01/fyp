import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/screens/calm/meditation_tracks_screen.dart';
import 'package:intl/intl.dart';

class CalmMainScreen extends StatefulWidget {
  const CalmMainScreen({Key? key}) : super(key: key);

  @override
  State<CalmMainScreen> createState() => _CalmMainScreenState();
}

class _CalmMainScreenState extends State<CalmMainScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textAnimationController;
  Timer? _timer;
  String _currentPhase = 'Inhale';
  int _secondsRemaining = 5;
  bool _isRunning = false;
  bool _isBreathingMode = true;

  List<List<Color>> gradientColors = [
    [Colors.indigo.shade900, Colors.black],
    [Colors.deepPurple.shade900, Colors.black],
    [Colors.blueGrey.shade900, Colors.black],
    [Colors.teal.shade900, Colors.black],
  ];
  int _gradientIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
      lowerBound: 0.5,
      upperBound: 1.0,
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textAnimationController.forward();
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
      _currentPhase = 'Inhale';
      _secondsRemaining = 5;
    });
    _controller.forward(from: 0.5);
    _textAnimationController.forward(from: 0.0);
    _startTimer();
    _startGradientCycling();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _switchPhase();
      }
    });
  }

  void _switchPhase() {
    _timer?.cancel();
    _textAnimationController.forward(from: 0.0);

    if (_currentPhase == 'Inhale') {
      _currentPhase = 'Exhale';
      _secondsRemaining = 5;
      _controller.reverse(from: 1.0);
    } else {
      _currentPhase = 'Inhale';
      _secondsRemaining = 5;
      _controller.forward(from: 0.5);
    }

    setState(() {});
    _startTimer();
  }

  void _startGradientCycling() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isRunning) {
        timer.cancel();
      } else {
        setState(() {
          _gradientIndex = (_gradientIndex + 1) % gradientColors.length;
        });
      }
    });
  }

  void _stopExercise() {
    _timer?.cancel();
    _controller.stop();
    _textAnimationController.stop();
    setState(() {
      _isRunning = false;
      _currentPhase = 'Inhale';
      _secondsRemaining = 5;
    });
  }

  // 🔥 STREAK TRACKING 🔥
  Future<void> _updateMeditationStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final streakRef = FirebaseFirestore.instance.collection('streaks').doc(user.uid);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final doc = await streakRef.get();
    if (!doc.exists) {
      await streakRef.set({
        'lastMeditationDate': today,
        'meditationStreak': 1,
      });
    } else {
      final data = doc.data()!;
      final lastDate = data['lastMeditationDate'];
      final currentStreak = data['meditationStreak'] ?? 0;

      final lastDateTime = DateTime.tryParse(lastDate) ?? DateTime.now();
      final difference = DateTime.now().difference(lastDateTime).inDays;

      if (difference == 0) {
        // already counted for today — do nothing
        return;
      } else if (difference == 1) {
        // consecutive day — increment streak
        await streakRef.update({
          'lastMeditationDate': today,
          'meditationStreak': currentStreak + 1,
        });
      } else {
        // missed a day — reset streak
        await streakRef.update({
          'lastMeditationDate': today,
          'meditationStreak': 1,
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBreathingMode ? Icons.self_improvement : Icons.spa,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _isBreathingMode = !_isBreathingMode;
                _stopExercise();
              });

              // 🎯 Track streak when switching to Meditation Mode
              if (!_isBreathingMode) {
                _updateMeditationStreak();
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors[_gradientIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isBreathingMode
            ? _buildBreathingMode()
            : MeditationTracksScreen(),
      ),
    );
  }

  Widget _buildBreathingMode() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _textAnimationController,
            child: ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _textAnimationController,
                  curve: Curves.easeOut,
                ),
              ),
              child: Text(
                _currentPhase,
                style: GoogleFonts.dancingScript(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ScaleTransition(
            scale: _controller,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.black54],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '$_secondsRemaining s',
            style: const TextStyle(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _isRunning ? _stopExercise : _startExercise,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 12,
              shadowColor: Colors.white.withOpacity(0.7),
            ),
            child: Text(
              _isRunning ? 'Stop' : 'Start',
              style: GoogleFonts.actor(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
