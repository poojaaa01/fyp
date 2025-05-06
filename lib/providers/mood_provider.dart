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
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('userMoods') // ✅ Proper subcollection
          .doc(moodEntry.id)
          .set(moodEntry.toMap());

      _moods.add(moodEntry);
      notifyListeners();
      Fluttertoast.showToast(msg: "Mood added successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving mood: $e");
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
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('userMoods') // ✅ Subcollection read
          .orderBy('timestamp', descending: true)
          .get();

      _moods.clear();
      for (var doc in snapshot.docs) {
        _moods.add(MoodModel.fromMap(doc.data()));
      }

      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching moods: $e");
      rethrow;
    }
  }

}
