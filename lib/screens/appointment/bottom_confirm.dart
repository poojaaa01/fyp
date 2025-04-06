import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:fyp/widgets/title_text.dart';

class AptBottomSheetWidget extends StatelessWidget {
  const AptBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
            top: BorderSide(
              width: 1.5,
              color: Colors.grey,
            ))
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
                      label: "Rs.\1600",
                      color: Colors.deepPurple,
                  )
                ],
              ),
              ElevatedButton(
                onPressed: (){},
                child: const Text("Checkout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
