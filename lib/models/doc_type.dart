import 'package:flutter/cupertino.dart';

class DoctorType with ChangeNotifier{
  final String docId,
      docTitle,
      docPrice,
      docCategory,
      docDescription,
      docImage,
      docQuantity;

  DoctorType({
    required this.docId,
    required this.docTitle,
    required this.docPrice,
    required this.docCategory,
    required this.docDescription,
    required this.docImage,
    required this.docQuantity,
  });
}
