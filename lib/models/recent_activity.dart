import 'package:flutter/material.dart';

class RecentActivityModel with ChangeNotifier {
  final String recentActId;
  final String activityType; // 'doctor', 'mood', 'focus'
  final String? docId;
  final String message;
  final DateTime timestamp;

  RecentActivityModel({
    required this.recentActId,
    required this.activityType,
    this.docId,
    required this.message,
    required this.timestamp,
  });
}
