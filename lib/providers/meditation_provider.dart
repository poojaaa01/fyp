import 'package:flutter/material.dart';
import '../models/meditation_track.dart';

class MeditationProvider with ChangeNotifier {
  final List<MeditationTrack> _tracks = [
    MeditationTrack(
      title: 'Sleep Journey',
      description: 'Relax into restful sleep with calming sounds.',
      audioPath: 'assets/audio/calm1.mp3',
    ),
    MeditationTrack(
      title: 'Stress Relief',
      description: 'Ease your mind and let go of stress.',
      audioPath: 'assets/audio/calm2.mp3',
    ),
    MeditationTrack(
      title: 'Relax & Unwind',
      description: 'Gentle melodies for peaceful moments.',
      audioPath: 'assets/audio/calm3.mp3',
    ),
    MeditationTrack(
      title: 'Spiritual',
      description: 'Sounds to boost your mental focus.',
      audioPath: 'assets/audio/calm4.mp3',
    ),
  ];

  List<MeditationTrack> get tracks => _tracks;
}
