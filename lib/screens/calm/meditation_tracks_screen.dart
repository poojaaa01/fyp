import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meditation_provider.dart';
import 'audio_player_screen.dart';

class MeditationTracksScreen extends StatelessWidget {
  const MeditationTracksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meditationTracks = Provider.of<MeditationProvider>(context).tracks;

    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: meditationTracks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final track = meditationTracks[index];
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MeditationPlayerScreen(track: track),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: Text(
              track.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }
}
