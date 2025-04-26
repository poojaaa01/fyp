import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_model.dart';

class MoodProvider with ChangeNotifier {
  final List<MoodModel> _moods = [];

  List<MoodModel> get moods => _moods;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMood({required String mood, String? note}) async {
    final user = _auth.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: "Please login first");
      return;
    }

    final moodEntry = MoodModel(
      id: const Uuid().v4(),
      mood: mood,
      note: note,
      timestamp: DateTime.now(),
      userId: user.uid,
    );

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'userMoods': FieldValue.arrayUnion([moodEntry.toMap()]),
      });

      _moods.add(moodEntry);
      notifyListeners();
      Fluttertoast.showToast(msg: "Mood added successfully");
    } catch (e) {
      rethrow;
    }
  }


  Future<void> fetchMoods() async {
    final user = _auth.currentUser;
    if (user == null) {
      _moods.clear();
      notifyListeners();
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      final data = userDoc.data();
      if (data == null || !data.containsKey('userMoods')) {
        _moods.clear();
        notifyListeners();
        return;
      }

      final moodsList = List<Map<String, dynamic>>.from(data['userMoods']);
      _moods.clear();

      for (var moodMap in moodsList) {
        _moods.add(MoodModel.fromMap(moodMap));
      }

      // Sort by timestamp (newest first)
      _moods.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching moods: $e");
      rethrow;
    }
  }

}
