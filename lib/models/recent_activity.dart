import 'package:flutter/material.dart';

class RecentActivityModel with ChangeNotifier {
  final String recentActId;
  final String docId;

  RecentActivityModel({
    required this.recentActId,
    required this.docId,
  });
}
