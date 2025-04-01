import 'package:flutter/material.dart';
import 'package:fyp/widgets/title_text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 25});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 5),
        baseColor: Colors.purple,
        highlightColor: Colors.red,
        child: TitlesTextWidget(label: "Moksha", fontSize: fontSize,),);
  }
}
