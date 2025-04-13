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
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: (){
          log("ToDo add the navigate to the product details screen");
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(imageUrl: AppConstants.imageUrl,
              height: size.height*0.22,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: TitlesTextWidget(
                      label: "Title "*10,
                      fontSize: 18,
                      maxLines: 2,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                      child: IconButton(onPressed: (){}, icon: Icon(IconlyLight.heart),
                      ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: SubtitleTextWidget(
                        label: "\Rs. 1550",
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                    ),
                  ),
                  Flexible(
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),
                      //color: Colors.lightBlue,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () {},
                        splashColor: Colors.yellow,
                          child: const Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.add_shopping_cart_outlined),
                          ),
                          ),
                    ),
                    ),
                    ],
                  ),
            ),
            const SizedBox(
              height: 12.0,
            ),
              ],
            ),
      ),
      );
  }
}
