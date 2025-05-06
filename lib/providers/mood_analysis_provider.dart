import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodAnalysisProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch all mood logs for current user
  Future<List<Map<String, dynamic>>> fetchMoodLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("🚫 No user logged in!");
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('userMoods')
        .get();

    print("✅ Fetched ${snapshot.docs.length} mood docs");

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final mood = data['mood'];
      final rawTimestamp = data['timestamp'];
      DateTime? date;

      if (rawTimestamp is Timestamp) {
        date = rawTimestamp.toDate();
      } else if (rawTimestamp is String) {
        date = DateTime.tryParse(rawTimestamp);
      }

      if (mood == null || date == null) {
        print("⚠️ Skipped invalid mood doc: ${doc.id}");
        return null;
      }

      return {
        'mood': mood,
        'date': date,
      };
    }).whereType<Map<String, dynamic>>().toList();
  }

  // Get mood distribution (for pie chart)
  Future<Map<String, int>> getMoodDistribution() async {
    final moodLogs = await fetchMoodLogs();
    print("📊 Fetched mood logs: $moodLogs");

    final moodMap = <String, int>{};

    for (var log in moodLogs) {
      final mood = log['mood'];
      moodMap[mood] = (moodMap[mood] ?? 0) + 1;
    }

    print("📈 Mood Distribution Data: $moodMap");
    return moodMap;
  }

  // Convert mood to numerical value (for line chart)
  double getMoodValue(String mood) {
    switch (mood) {
      case 'Happy':
        return 1.0;
      case 'Sad':
        return -1.0;
      case 'Neutral':
        return 0.0;
      case 'Excited':
        return 1.5;
      case 'Angry':
        return -1.5;
      default:
        return 0.0;
    }
  }

  // Prepare mood data for line chart
  Future<List<FlSpot>> getMoodTrendSpots() async {
    final moodLogs = await fetchMoodLogs();
    final spots = <FlSpot>[];

    for (var i = 0; i < moodLogs.length; i++) {
      final moodValue = getMoodValue(moodLogs[i]['mood']);
      spots.add(FlSpot(i.toDouble(), moodValue));
    }

    return spots;
  }
}
