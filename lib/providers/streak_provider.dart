import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MeditationStreakProvider with ChangeNotifier {
  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastActiveDate;

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;

  Future<void> fetchMeditationStreak(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('streaks')
        .doc('meditation')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _currentStreak = data['currentStreak'];
      _longestStreak = data['longestStreak'];
      _lastActiveDate = DateTime.tryParse(data['lastActiveDate']);
    }
    notifyListeners();
  }

  Future<void> updateMeditationStreak(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastActiveDate != null) {
      final lastDate = DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
      if (today.difference(lastDate).inDays == 1) {
        _currentStreak++;
      } else if (today.difference(lastDate).inDays > 1) {
        _currentStreak = 1;
      }
    } else {
      _currentStreak = 1;
    }

    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }

    _lastActiveDate = today;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('streaks')
        .doc('meditation')
        .set({
      'currentStreak': _currentStreak,
      'longestStreak': _longestStreak,
      'lastActiveDate': _lastActiveDate!.toIso8601String(),
    });

    notifyListeners();
  }
}
