import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meditation_provider.dart';
import 'audio_player_screen.dart';

class MeditationTracksScreen extends StatefulWidget {
  const MeditationTracksScreen({Key? key}) : super(key: key);

  @override
  State<MeditationTracksScreen> createState() => _MeditationTracksScreenState();
}

class _MeditationTracksScreenState extends State<MeditationTracksScreen> {
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  @override
  Widget build(BuildContext context) {
    final meditationTracks = Provider.of<MeditationProvider>(context).tracks;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Meditation Tracks',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // center title properly
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Timer section directly under title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: selectedMinutes,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white),
                      items: List.generate(60, (index) => index)
                          .map((val) => DropdownMenuItem(value: val, child: Text('$val min')))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedMinutes = val!;
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<int>(
                      value: selectedSeconds,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white),
                      items: List.generate(60, (index) => index)
                          .map((val) => DropdownMenuItem(value: val, child: Text('$val sec')))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedSeconds = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Buttons section
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  itemCount: meditationTracks.length,
                  itemBuilder: (context, index) {
                    final track = meditationTracks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MeditationPlayerScreen(
                                track: track,
                                selectedMinutes: selectedMinutes,
                                selectedSeconds: selectedSeconds,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          track.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
