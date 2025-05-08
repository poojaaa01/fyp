import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/models/appointment_model.dart';
import 'package:fyp/services/app_functions.dart';
import 'package:uuid/uuid.dart';

import 'doc_provider.dart';

class AptProvider with ChangeNotifier {
  final Map<String, AptModel> _aptItems = {};

  Map<String, AptModel> get getAptitems {
    return _aptItems;
  }

  final userDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  //Firebase
  Future<void> appointmentFirebase({
    required String docId,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please login first",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final appointmentId = const Uuid().v4();
    try {
      await userDb.doc(uid).update({
        'userAppointment': FieldValue.arrayUnion([
          {'appointmentId': appointmentId, 'docId': docId},
        ]),
      });
      await fetchAppointment();
      Fluttertoast.showToast(msg: "Appointment is added");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAppointment() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _aptItems.clear();
      return;
    }
    try {
      final userDoc = await userDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userAppointment')) {
        return;
      }
      final List<dynamic> appointments = data['userAppointment'];

      _aptItems.clear();
      for (var appointment in appointments) {
        final String appointmentId = appointment['appointmentId'];
        final String docId = appointment['docId'];

        _aptItems.putIfAbsent(
          docId,
              () => AptModel(
            aptId: appointmentId,
            docId: docId,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeAptItemFromFirestore({
    required String appointmentId,
    required String docId,
  }) async {
    final User? user = _auth.currentUser;
    try {
      await userDb.doc(user!.uid).update({
        'userAppointment': FieldValue.arrayRemove([
          {'appointmentId': appointmentId, 'docId': docId},
        ]),
      });
      //await fetchAppointment();
      _aptItems.remove(docId);
      Fluttertoast.showToast(msg: "One appointment has been removed");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearAptFromFirebase()async{
    final User? user = _auth.currentUser;
    try {
      await userDb.doc(user!.uid).update({
        'userAppointment': [],
      });
      //await fetchAppointment();
      _aptItems.clear();
      Fluttertoast.showToast(msg: "Your appointment has been cleared");
    } catch (e) {
      rethrow;
    }

  }

  //Local
  void addDoctorToAppointment({required String docId}) {
    _aptItems.putIfAbsent(
      docId,
      () => AptModel(aptId: const Uuid().v4(), docId: docId),
    );
    notifyListeners();
  }

  bool isDocinApt({required String docId}) {
    return _aptItems.containsKey(docId);
  }

  double getTotal({required DocProvider docProvider}) {
    double total = 0.0;
    _aptItems.forEach((key, value) {
      final getCurrDoctor = docProvider.findByDocId(value.docId);
      if (getCurrDoctor == null) {
        total += 0;
      } else {
        total += double.parse(getCurrDoctor.docPrice);
      }
    });
    return total;
  }

  void clearLocalAppointment() {
    _aptItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String docId}) {
    _aptItems.remove(docId);
    notifyListeners();
  }
}
