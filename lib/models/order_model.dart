import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrdersModelAdvanced with ChangeNotifier {
  final String bookId;
  final String userId;
  final String userEmail;
  final String docId;
  final String docTitle;
  final String userName;
  final String price;
  final String imageUrl;
  final Timestamp bookDate;

  OrdersModelAdvanced(
      {required this.bookId,
        required this.userId,
        required this.userEmail,
        required this.docId,
        required this.docTitle,
        required this.userName,
        required this.price,
        required this.imageUrl,
        required this.bookDate});
}
