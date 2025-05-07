import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  static Future<void> updateMeditationStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final streakRef = FirebaseFirestore.instance
        .collection('streaks')
        .doc(user.uid);

    final streakSnapshot = await streakRef.get();
    final today = DateTime.now(); // Moved this up to be available in all blocks

    if (streakSnapshot.exists) {
      final lastMeditationDate = streakSnapshot['lastMeditationDate'].toDate();

      // Check if last session was yesterday
      if (isSameDay(today.subtract(const Duration(days: 1)), lastMeditationDate)) {
        // Increment streak
        final currentStreak = streakSnapshot['meditationStreak'] ?? 0;
        await streakRef.update({
          'meditationStreak': currentStreak + 1,
          'lastMeditationDate': today,
        });
      } else if (!isSameDay(today, lastMeditationDate)) {
        // Reset streak if not consecutive
        await streakRef.set({
          'meditationStreak': 1,
          'lastMeditationDate': today,
        }, SetOptions(merge: true));
      }
      // Else: Do nothing if already meditated today
    } else {
      // No streak exists → start new one
      await streakRef.set({
        'meditationStreak': 1,
        'lastMeditationDate': today, // Now 'today' is available here
      });
    }
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}