import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:fyp/widgets/title_text.dart';

import '../../consts/app_constants.dart';


class DocWidget extends StatefulWidget {
  const DocWidget({super.key});

  @override
  State<DocWidget> createState() => _DocWidgetState();
}

class _DocWidgetState extends State<DocWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FancyShimmerImage(imageUrl: AppConstants.imageUrl)
      ],
    );
  }
}
