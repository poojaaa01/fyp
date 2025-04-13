import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/appointment/bottom_confirm.dart';
import 'package:fyp/widgets/empty_apt.dart';

import '../../services/assets_manager.dart';
import '../../widgets/products/doc_widget.dart';
import '../../widgets/title_text.dart';

class RecentActivityScreen extends StatelessWidget {
  static const routName = "/RecentActivityScreen";

  const RecentActivityScreen({super.key});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isEmpty
        ? Scaffold(
          body: EmptyAptWidget(
            imagePath: AssetsManager.noApt,
            title: "No activity detected",
            subtitle: "Want to set one?",
            buttonText: "Book an Appointment",
          ),
        )
        : Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.logoApp),
            ),
            title: const TitlesTextWidget(label: "Recent Activity"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever_rounded),
              ),
            ],
          ),
          body: DynamicHeightGridView(
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            builder: (context, index) {
              return const DocWidget();
            },
            itemCount: 200,
            crossAxisCount: 2,
          ),
        );
  }
}
