import 'package:flutter/material.dart';
import 'package:fyp/models/appointment_model.dart';
import 'package:uuid/uuid.dart';

class AptProvider with ChangeNotifier {
  final Map<String, AptModel> _aptItems = {};
  Map<String, AptModel> get getAptitems {
    return _aptItems;
  }

  void addDoctorToAppointment({required String docId}) {
    _aptItems.putIfAbsent(
      docId,
          () => AptModel(
          aptId: const Uuid().v4(), docId: docId),
    );
    notifyListeners();
  }

  bool isDocinApt({required String docId}) {
    return _aptItems.containsKey(docId);
  }
}
