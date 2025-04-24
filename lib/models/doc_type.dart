import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DoctorType with ChangeNotifier {
  final String docId,
      docTitle,
      docPrice,
      docCategory,
      docDescription,
      docImage;
  Timestamp? createdAt;

  DoctorType({
    required this.docId,
    required this.docTitle,
    required this.docPrice,
    required this.docCategory,
    required this.docDescription,
    required this.docImage,
    this.createdAt,
  });

  factory DoctorType.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return DoctorType(
      docId: data['docId'] ?? doc.id,
      docTitle: data['docTitle'] ?? data['docName'] ?? 'No Name', // Handle both
      docPrice: data['docPrice']?.toString() ?? '0',
      docCategory: data['docCategory'] ?? 'No Category',
      docDescription: data['docDescription'] ?? 'No Description',
      docImage: data['docImage'] ?? 'No Image',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }
}
