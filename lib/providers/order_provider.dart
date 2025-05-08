import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrdersModelAdvanced> orders = [];

  List<OrdersModelAdvanced> get getOrders => orders;

  Future<List<OrdersModelAdvanced>> fetchOrder() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var uid = user!.uid;
    try {
      await
      FirebaseFirestore.instance.collection("ordersAdvanced").where('userId', isEqualTo: uid).orderBy("bookDate", descending: false)
          .get().then((
          orderSnapshot) {
        orders.clear();
        for (var element in orderSnapshot.docs) {
          orders.insert(0, OrdersModelAdvanced(
            bookId: element.get('bookId'),
            userId: element.get('userId'),
            docId: element.get('docId'),
            docTitle: element.get('docTitle').toString(),
            userName: element.get('userName'),
            price: element.get('price').toString(),
            imageUrl: element.get('imageUrl'),
            bookDate: element.get('bookDate'),
            userEmail: element.data().containsKey('userEmail') ? element.get('userEmail') : '',
          ));
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }
}