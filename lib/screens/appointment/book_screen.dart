import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/appointment/bottom_confirm.dart';
import 'package:fyp/services/app_functions.dart';
import 'package:fyp/widgets/empty_apt.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/doc_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/assets_manager.dart';
import '../../widgets/title_text.dart';
import '../loading_manager.dart';
import 'book_widget.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    //final docProvider = Provider.of<DocProvider>(context);
    final docProvider = Provider.of<DocProvider>(context, listen: false);
    final aptProvider = Provider.of<AptProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return aptProvider.getAptitems.isEmpty
        ? Scaffold(
          body: EmptyAptWidget(
            imagePath: AssetsManager.noApt,
            title: "No appointment scheduled...",
            subtitle: "Want to set one?",
            buttonText: "Book an Appointment",
          ),
        )
        : Scaffold(
          bottomSheet: AptBottomSheetWidget(
            function: () async {
              await placeOrderAdvanced(
                aptProvider: aptProvider,
                docProvider: docProvider,
                userProvider: userProvider,
              );
            },
          ),
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.logoApp),
            ),
            title: TitlesTextWidget(
              label: "Appointment (${aptProvider.getAptitems.length})",
            ),
            actions: [
              IconButton(
                onPressed: () {
                  AppFunctions.showErrorOrWarningDialog(
                    isError: false,
                    context: context,
                    subtitle: "Are you sure?",
                    fct: () async {
                      aptProvider.clearAptFromFirebase();
                      //aptProvider.clearLocalAppointment();
                    },
                  );
                },
                icon: const Icon(Icons.delete_forever_rounded),
              ),
            ],
          ),
          body: LoadingManager(
            isLoading: _isLoading,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: aptProvider.getAptitems.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: aptProvider.getAptitems.values.toList()[index],
                        child: const BookWidget(),
                      );
                    },
                  ),
                ),
                SizedBox(height: kBottomNavigationBarHeight + 10),
              ],
            ),
          ),
        );
  }

  Future<void> placeOrderAdvanced({
    required AptProvider aptProvider,
    required DocProvider docProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        _isLoading = true;
      });
      aptProvider.getAptitems.forEach((key, value) async {
        final getCurrDoctor = docProvider.findByDocId(value.docId);
        final bookId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .doc(bookId)
            .set({
              'bookId': bookId,
              'userId': uid,
              'docId': value.docId,
              "docTitle": getCurrDoctor!.docTitle,
              'price': double.parse(getCurrDoctor.docPrice),
              'totalPrice': aptProvider.getTotal(docProvider: docProvider),
              'imageUrl': getCurrDoctor.docImage,
              'userName': userProvider.getUserModel!.userName,
              'bookDate': Timestamp.now(),
            });
      });
      await aptProvider.clearAptFromFirebase();
      aptProvider.clearLocalAppointment();
    } catch (e) {
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
