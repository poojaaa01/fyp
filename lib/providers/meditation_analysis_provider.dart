import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MeditationAnalysisProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchMeditationSessions(String userId) async {
    final sessionsSnapshot = await _firestore
        .collection('meditation_history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp')
        .get();

    final List<Map<String, dynamic>> sessions = [];

    for (int i = 0; i < sessionsSnapshot.docs.length; i++) {
      final data = sessionsSnapshot.docs[i].data();
      final duration = data['sessionDurationSeconds'] as int? ?? 0;

      sessions.add({
        'duration': duration,
        'xIndex': i, // Use index for X-axis to space bars correctly
      });
    }

    return sessions;
  }
}



