import 'dart:async';
import 'package:flutter/material.dart';
import 'recent_activity_provider.dart';
import 'package:provider/provider.dart';

class FocusSession {
  DateTime startTime;

  FocusSession() : startTime = DateTime.now();
}

class FocusSessionProvider with ChangeNotifier {
  FocusSession? _currentSession;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _elapsedBeforePause = Duration.zero;
  bool _isRunning = false;

  FocusSession? get currentSession => _currentSession;
  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  void startSession() {
    _currentSession = FocusSession();
    _elapsed = Duration.zero;
    _elapsedBeforePause = Duration.zero;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed = DateTime.now().difference(_currentSession!.startTime) + _elapsedBeforePause;
      notifyListeners();
    });

    notifyListeners();
  }

  void pauseSession() {
    if (_currentSession == null) return;

    _timer?.cancel();
    _elapsedBeforePause += DateTime.now().difference(_currentSession!.startTime);
    _isRunning = false;
    notifyListeners();
  }

  void resumeSession() {
    if (_currentSession == null) return;

    _currentSession!.startTime = DateTime.now();
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed = DateTime.now().difference(_currentSession!.startTime) + _elapsedBeforePause;
      notifyListeners();
    });

    notifyListeners();
  }

  void stopSession(BuildContext context) {
    _timer?.cancel();

    if (_currentSession != null) {
      final totalDuration = _elapsed; // Use the actual tracked elapsed time

      Provider.of<RecentActivityProvider>(context, listen: false)
          .addFocusActivity(duration: "${totalDuration.inMinutes} minutes");
    }

    _currentSession = null;
    _elapsed = Duration.zero;
    _elapsedBeforePause = Duration.zero;
    _isRunning = false;
    notifyListeners();
  }
}
