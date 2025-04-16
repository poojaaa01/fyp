import 'package:flutter/material.dart';
import 'package:fyp/models/appointment_model.dart';
import 'package:uuid/uuid.dart';

import 'doc_provider.dart';

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

  double getTotal({required DocProvider docProvider}){
    double total = 0.0;
    _aptItems.forEach((key, value) {
      final getCurrDoctor = docProvider.findByDocId(value.docId);
      if(getCurrDoctor == null){
        total += 0;
      } else{
        total += double.parse(getCurrDoctor.docPrice);
      }
    });
    return total;
  }

  void clearLocalAppointment () {
    _aptItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String docId}){
    _aptItems.remove(docId);
    notifyListeners();
  }
}
