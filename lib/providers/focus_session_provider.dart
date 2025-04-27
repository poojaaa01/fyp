import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/focus_session_model.dart';

class FocusSessionProvider with ChangeNotifier {
  FocusSession? _currentSession;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  Duration get elapsed => _elapsed;
  bool get isRunning => _timer != null && _timer!.isActive;
  FocusSession? get currentSession => _currentSession;

  void startSession() {
    final newSession = FocusSession(
      id: const Uuid().v4(),
      startTime: DateTime.now(),
    );

    _currentSession = newSession;
    _elapsed = Duration.zero;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });

    notifyListeners();
  }

  void pauseSession() {
    _timer?.cancel();
    notifyListeners();
  }

  void resumeSession() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stopSession({bool isCompleted = true}) async {
    _timer?.cancel();

    if (_currentSession != null) {
      final updatedSession = FocusSession(
        id: _currentSession!.id,
        startTime: _currentSession!.startTime,
        endTime: DateTime.now(),
        duration: _elapsed,
        isCompleted: isCompleted,
      );

      await FirebaseFirestore.instance
          .collection('focus_sessions')
          .doc(updatedSession.id)
          .set(updatedSession.toMap());

      _currentSession = null;
      _elapsed = Duration.zero;
      notifyListeners();
    }
  }

  void resetSession() {
    _timer?.cancel();
    _currentSession = null;
    _elapsed = Duration.zero;
    notifyListeners();
  }
}
