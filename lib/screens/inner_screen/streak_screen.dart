import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/calm/calm_screen.dart';

import '../../services/app_functions.dart';
import '../../services/assets_manager.dart';

class StreakScreen extends StatefulWidget {
  static const routeName = '/streak-screen';
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  int currentStreak = 0;
  int lastStreak = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStreakData();
  }

  Future<void> fetchStreakData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('streaks')  // ✅ Correct collection
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          currentStreak = data['meditationStreak'] ?? 0;  // ✅ 'meditationStreak'
          // lastStreak is optional (remove if not stored)
        });
      }
    } catch (e) {
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset(
            //   AssetsManager.logoApp,
            //   height: 32,
            // ),
            const Text(
              'Your Streak',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentStreak > 0)
                Column(
                  children: [
                    Text(
                      "🔥 Current Streak: $currentStreak days",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              else if (lastStreak > 0)
                Column(
                  children: [
                    Text(
                      "You had a $lastStreak 🔥 streak before!",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: Image.asset(
                        AssetsManager.calm,
                        height: 26,
                      ),
                      label: const Text("Start one now"),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CalmMainScreen()),
                        );
                      },
                    ),
                  ],
                )
              else
                const Text(
                  "You don't have a streak yet.\nStart one today 🔥",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
