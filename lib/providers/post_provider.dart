import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostProvider with ChangeNotifier {
  List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  final _firestore = FirebaseFirestore.instance;

  Future<void> fetchPosts() async {
    final snapshot = await _firestore
        .collection('community_posts')
        .orderBy('timestamp', descending: true)
        .get();

    _posts = snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data(), doc.id))
        .toList();

    notifyListeners();
  }

  Future<void> addPost(String content, String authorName) async {
    final newPost = PostModel(
      id: '',
      content: content,
      authorName: authorName,
      timestamp: DateTime.now(),
      likes: 0,
      comments: [],
    );

    await _firestore.collection('community_posts').add(newPost.toMap());
    await fetchPosts();
  }
}
