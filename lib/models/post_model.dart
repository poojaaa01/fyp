import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String content;
  final String authorName;
  final DateTime timestamp;
  final int likes;
  final List<String> comments;

  PostModel({
    required this.id,
    required this.content,
    required this.authorName,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  // Factory constructor to create a PostModel from Firestore data
  factory PostModel.fromMap(Map<String, dynamic> map, String docId) {
    return PostModel(
      id: docId,
      content: map['content'] ?? '',
      authorName: map['authorName'] ?? 'Anonymous',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      likes: map['likes'] ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
    );
  }

  // Convert PostModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'authorName': authorName,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments,
    };
  }
}
