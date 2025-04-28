import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalmMainScreen extends StatefulWidget {
  const CalmMainScreen({Key? key}) : super(key: key);

  @override
  State<CalmMainScreen> createState() => _CalmMainScreenState();
}

class _CalmMainScreenState extends State<CalmMainScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textAnimationController;
  Timer? _timer;
  String _currentPhase = 'Inhale';
  int _secondsRemaining = 5;
  bool _isRunning = false;
  bool _isMeditationMode = false;

  List<List<Color>> gradientColors = [
    [Colors.purple.shade200, Colors.blue.shade100],
    [Colors.blue.shade200, Colors.teal.shade100],
    [Colors.teal.shade200, Colors.green.shade100],
    [Colors.green.shade200, Colors.purple.shade100],
  ];
  int _gradientIndex = 0;

  List<String> meditationOptions = [
    'Sleep',
    'Stress Relief',
    'Relaxation',
    'Focus'
  ];
  String selectedMeditation = 'Sleep';

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
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            onPressed: () {
              setState(() {
                _isMeditationMode = !_isMeditationMode;
              });
            },
          )
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
        child: Center(
          child: _isMeditationMode ? _buildMeditationMode() : _buildBreathingMode(),
        ),
      ),
    );
  }

  Widget _buildBreathingMode() {
    return Column(
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
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.blue, Color(0xFFE0E0E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
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
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 12,
            shadowColor: Colors.white.withOpacity(0.7),
          ),
          child: Text(
            _isRunning ? 'Stop' : 'Start',
            style: GoogleFonts.actor(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationMode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Meditation',
          style: GoogleFonts.dancingScript(
            fontSize: 48,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        DropdownButton<String>(
          value: selectedMeditation,
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          onChanged: (String? newValue) {
            setState(() {
              selectedMeditation = newValue!;
            });
          },
          items: meditationOptions
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            // Play selected meditation audio/video here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 12,
            shadowColor: Colors.white.withOpacity(0.7),
          ),
          child: const Text('Start Meditation'),
        ),
      ],
    );
  }
}
