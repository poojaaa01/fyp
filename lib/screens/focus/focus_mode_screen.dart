import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/focus_session_provider.dart';
import '../../providers/recent_activity_provider.dart';
import 'dart:math';

import '../../services/assets_manager.dart';

class FocusModeScreen extends StatelessWidget {
  const FocusModeScreen({super.key});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void showMotivationDialog(BuildContext context) {
    final messages = [
      "Awesome work! Keep it up 🚀",
      "We’re proud of you 💪",
      "Another step closer to your goals ✨",
      "You’re doing amazing, stay consistent 👏",
      "Small steps lead to big results 🔥",
      "You nailed it! Keep going 🌱",
    ];

    final random = Random();
    final message = messages[random.nextInt(messages.length)];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Great Job! 🎉"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Thanks!"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<FocusSessionProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset(
            //   AssetsManager.logoApp,
            //   height: 32,
            // ),
            const Text(
              'Focus Mode',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                color: Colors.white,),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatDuration(sessionProvider.elapsed),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              children: [
                if (sessionProvider.currentSession == null)
                  ElevatedButton(
                    onPressed: () {
                      sessionProvider.startSession();
                    },
                    child: const Text('Start'),
                  )
                else ...[
                  if (sessionProvider.isRunning)
                    ElevatedButton(
                      onPressed: () {
                        sessionProvider.pauseSession();
                      },
                      child: const Text('Pause'),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        sessionProvider.resumeSession();
                      },
                      child: const Text('Resume'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      final duration = sessionProvider.elapsed;
                      sessionProvider.stopSession(context);
                      showMotivationDialog(context);

                      Provider.of<RecentActivityProvider>(context, listen: false)
                          .addFocusActivity(duration: "${duration.inMinutes} minutes");
                    },
                    child: const Text('Stop'),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
