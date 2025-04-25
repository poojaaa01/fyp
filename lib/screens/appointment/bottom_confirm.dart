import 'package:flutter/material.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:fyp/widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/doc_provider.dart';

class AptBottomSheetWidget extends StatelessWidget {
  const AptBottomSheetWidget({super.key, required this.function});

  final Function function;

  @override
  Widget build(BuildContext context) {
    final docProvider = Provider.of<DocProvider>(context);
    final aptProvider = Provider.of<AptProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(width: 1.5, color: Colors.grey)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TitlesTextWidget(label: "Total"),
                  SubtitleTextWidget(
                    label: "${aptProvider.getTotal(docProvider: docProvider)}",
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              ElevatedButton(onPressed: () async{
                await function();
              }, child: const Text("Checkout")),
            ],
          ),
        ),
      ),
    );
  }
}
