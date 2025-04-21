import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/recent_activity.dart';

class RecentActivityProvider with ChangeNotifier {
  final Map<String, RecentActivityModel> _viewedDoc = {};

  Map<String, RecentActivityModel> get getViewedDoc {
    return _viewedDoc;
  }

  void addViewedDoc({required String docId}) {
    _viewedDoc.putIfAbsent(
      docId,
          () => RecentActivityModel(recentActId: Uuid().v4(), docId: docId),
    );

    notifyListeners();
  }

  void clearRecentAct () {
    _viewedDoc.clear();
    notifyListeners();
  }
}
