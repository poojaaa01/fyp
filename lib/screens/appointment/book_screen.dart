import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fyp/screens/appointment/bottom_confirm.dart';
import 'package:fyp/widgets/empty_apt.dart';
import 'package:fyp/widgets/subtitle_text.dart';

import '../../services/assets_manager.dart';
import '../../widgets/title_text.dart';
import 'book_widget.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});
final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isEmpty? Scaffold(
      body:  EmptyAptWidget(
          imagePath: AssetsManager.noApt,
          title: "No appointment scheduled...",
          subtitle: "Want to set one?",
          buttonText: "Book an Appointment")
      )
        : Scaffold(
      bottomSheet: const AptBottomSheetWidget(),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.logoApp,
          ),
        ),
        title: const TitlesTextWidget(label: "Appointment"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_forever_rounded),),
        ],
      ),
        body: ListView.builder(
          itemCount: 10,
        itemBuilder: (context, index) {
          return const BookWidget();
    }),
    );
  }
}
