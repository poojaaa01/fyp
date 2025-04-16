import 'package:flutter/material.dart';

class AptModel with ChangeNotifier {
  final String aptId;
  final String docId;

  AptModel({
    required this.aptId,
    required this.docId,
  });
}
