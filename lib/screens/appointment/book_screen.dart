import 'package:flutter/material.dart';
import 'package:fyp/screens/appointment/bottom_confirm.dart';
import 'package:fyp/widgets/empty_apt.dart';
import 'package:provider/provider.dart';

import '../../providers/appointment_provider.dart';
import '../../services/assets_manager.dart';
import '../../widgets/title_text.dart';
import 'book_widget.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    //final docProvider = Provider.of<DocProvider>(context);
    final aptProvider = Provider.of<AptProvider>(context);

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
          bottomSheet: const AptBottomSheetWidget(),
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.logoApp),
            ),
            title: TitlesTextWidget(label: "Appointment (${aptProvider.getAptitems.length})"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever_rounded),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: aptProvider.getAptitems.length,
            itemBuilder: (context, index) {
              return const BookWidget();
            },
          ),
        );
  }
}
