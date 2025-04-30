import 'package:flutter/material.dart';
import '../models/meditation_track.dart';
import '../screens/calm/audio_player_screen.dart';
import '../services/assets_manager.dart';

class MeditationCard extends StatelessWidget {
  final MeditationTrack track;
  final int selectedMinutes;
  final int selectedSeconds;

  const MeditationCard({
    required this.track,
    required this.selectedMinutes,
    required this.selectedSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.asset(
          AssetsManager.calm,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(track.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeditationPlayerScreen(
                track: track,
                selectedMinutes: selectedMinutes,
                selectedSeconds: selectedSeconds,
              ),
            ),
          );
        },
      ),
    );
  }
}
