import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fyp/root_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_provider.dart';
import 'mood_tracker_screen.dart';

class MoodLogScreen extends StatefulWidget {
  const MoodLogScreen({Key? key}) : super(key: key);

  @override
  State<MoodLogScreen> createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  String? selectedMood;
  String? selectedQuote;
  final TextEditingController _noteController = TextEditingController();
  final Random _random = Random();

  final List<String> moods = ['😊', '😐', '😢', '😡', '😴'];

  final Map<String, List<String>> moodQuotes = {
    '😊': [
      'Happiness is a choice, not a result.',
      'Smile — it suits you.',
      'Good vibes only today!',
    ],
    '😐': [
      'Stay calm, everything will fall into place.',
      'Not every day needs to be exciting.',
      'Neutral is okay too — embrace it.',
    ],
    '😢': [
      'Tough times never last, but tough people do.',
      'It’s okay to feel down — brighter days are ahead.',
      'Crying is a sign of strength, not weakness.',
    ],
    '😡': [
      'Breathe. It’s just a bad moment, not a bad life.',
      'Anger doesn’t solve problems, calm does.',
      'Step back, refocus, rise again.',
    ],
    '😴': [
      'Rest is productive too — take your time.',
      'Sleep is the best meditation.',
      'Recharge. You’ll shine tomorrow.',
    ],
  };

  void _selectMood(String mood) {
    setState(() {
      selectedMood = mood;
      final quotes = moodQuotes[mood];
      if (quotes != null && quotes.isNotEmpty) {
        selectedQuote = quotes[_random.nextInt(quotes.length)];
      } else {
        selectedQuote = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Log your Mood",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "How are you feeling?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: moods.map((mood) {
                    return GestureDetector(
                      onTap: () => _selectMood(mood),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedMood == mood
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                        ),
                        child: Text(
                          mood,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Display Random Quote
              if (selectedQuote != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    selectedQuote!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    labelText: "Do you want to express?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (selectedMood == null) return;

                      await Provider.of<MoodProvider>(context, listen: false)
                          .addMood(
                        mood: selectedMood!,
                        note: _noteController.text,
                      );

                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, RootScreen.routeName);
                    },
                    child: const Text(
                      "Save Mood",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}