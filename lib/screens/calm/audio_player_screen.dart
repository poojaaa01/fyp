import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/assets_manager.dart';
import '../../models/meditation_track.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final MeditationTrack track;
  final int selectedMinutes;
  final int selectedSeconds;

  const MeditationPlayerScreen({
    required this.track,
    required this.selectedMinutes,
    required this.selectedSeconds,
  });

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  late AudioPlayer _player;
  late Duration _remainingTime;
  Timer? _timer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlayer();
    _remainingTime = Duration(
        minutes: widget.selectedMinutes, seconds: widget.selectedSeconds);
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setAsset(widget.track.audioPath);
    } catch (e) {
      debugPrint('Audio load error: $e');
    }
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        timer.cancel();
        _player.stop();
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  String get timeLeftText {
    if (widget.selectedMinutes == 0 && widget.selectedSeconds == 0) {
      return "No Timer";
    } else {
      return "${_remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFa18cd1),
              Color(0xFFfbc2eb),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsManager.calm,
                    width: 220,
                    height: 220,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.track.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Time Left: $timeLeftText',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  IconButton(
                    iconSize: 110,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });

                      if (isPlaying) {
                        _player.play();
                        _startTimer();
                      } else {
                        _player.pause();
                        _pauseTimer();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
