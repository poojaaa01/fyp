import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/recent_activity.dart';

class RecentActivityProvider with ChangeNotifier {
  final List<RecentActivityModel> _recentActivities = [];

  List<RecentActivityModel> get getRecentActivities => _recentActivities;

  void addDoctorActivity({required String docId, required String message}) {
    _recentActivities.insert(
      0,
      RecentActivityModel(
        recentActId: const Uuid().v4(),
        activityType: 'doctor',
        docId: docId,
        message: message,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addMoodActivity({required String mood}) {
    _recentActivities.insert(
      0,
      RecentActivityModel(
        recentActId: const Uuid().v4(),
        activityType: 'mood',
        message: 'Mood logged: $mood',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addFocusActivity({required String duration}) {
    _recentActivities.insert(
      0,
      RecentActivityModel(
        recentActId: const Uuid().v4(),
        activityType: 'focus',
        message: 'Focus session completed: $duration',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void clearRecentActivities() {
    _recentActivities.clear();
    notifyListeners();
  }
}
