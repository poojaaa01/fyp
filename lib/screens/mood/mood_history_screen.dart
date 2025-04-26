import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_provider.dart';
import '../../models/mood_model.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch moods when the screen loads
    Future.delayed(Duration.zero, () {
      Provider.of<MoodProvider>(context, listen: false).fetchMoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mood Log History",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            //color: Colors.white,
          ),
        ),
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await moodProvider.fetchMoods(),
        child: moodProvider.moods.isEmpty
            ? const Center(child: Text("No mood history yet."))
            : ListView.builder(
          itemCount: moodProvider.moods.length,
          itemBuilder: (ctx, index) {
            MoodModel mood = moodProvider.moods[index];
            return ListTile(
              leading: Text(mood.mood, style: const TextStyle(fontSize: 28)),
              title: Text(mood.note?.isNotEmpty == true ? mood.note! : "No note"),
              subtitle: Text(
                mood.timestamp.toLocal().toString(),
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      ),
    );
  }
}
