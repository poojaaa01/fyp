import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class MoodModel {
  final String id;
  final String mood;
  final String? note;
  final DateTime timestamp;
  final String userId;

  MoodModel({
    required this.id,
    required this.mood,
    this.note,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
    };
  }

  // Optional alias for clarity when saving to Firestore
  Map<String, dynamic> toJson() => toMap();

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    try {
      return MoodModel(
        id: map['id'] ?? const Uuid().v4(),  // fallback id if missing
        mood: map['mood'] ?? '😊',           // fallback emoji
        note: map['note'],                   // note is nullable
        timestamp: map['timestamp'] != null
            ? DateTime.parse(map['timestamp'])
            : DateTime.now(),                // fallback if missing
        userId: map['userId'] ?? 'unknown',  // fallback userId
      );
    } catch (e) {
      debugPrint("Error parsing mood map: $e, data: $map");
      rethrow;
    }
  }

}
