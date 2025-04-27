import 'dart:async';
import 'package:flutter/material.dart';

import 'recent_activity_provider.dart';
import 'package:provider/provider.dart';

class FocusSession {
  final DateTime startTime;

  FocusSession() : startTime = DateTime.now();
}

class FocusSessionProvider with ChangeNotifier {
  FocusSession? _currentSession;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;

  FocusSession? get currentSession => _currentSession;
  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  void startSession() {
    _currentSession = FocusSession();
    _elapsed = Duration.zero;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed = DateTime.now().difference(_currentSession!.startTime);
      notifyListeners();
    });

    notifyListeners();
  }

  void pauseSession() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resumeSession() {
    if (_currentSession == null) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed = DateTime.now().difference(_currentSession!.startTime);
      notifyListeners();
    });

    notifyListeners();
  }

  void stopSession(BuildContext context) {
    _timer?.cancel();

    if (_currentSession != null) {
      final duration = DateTime.now().difference(_currentSession!.startTime);

      Provider.of<RecentActivityProvider>(context, listen: false)
          .addFocusActivity(duration: "${duration.inMinutes} minutes");
    }

    _currentSession = null;
    _elapsed = Duration.zero;
    _isRunning = false;
    notifyListeners();
  }
}
