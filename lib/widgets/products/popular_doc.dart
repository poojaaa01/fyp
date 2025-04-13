import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../consts/app_constants.dart';
import '../../screens/inner_screen/doc_details.dart';
import '../subtitle_text.dart';


class PopularDoctorsWidget extends StatelessWidget {
  const PopularDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, DocDetailsScreen.routName,
          );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                  child: FancyShimmerImage(
                    imageUrl:
                    'https://www.shutterstock.com/image-vector/male-doctor-smiling-happy-face-600nw-2481032615.jpg',
                    height: size.height*0.2,
                    width: size.height * 0.2,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Title" * 5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              IconlyLight.heart,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_shopping_cart,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const FittedBox(
                      child: SubtitleTextWidget(
                        label: "\Rs. 1550",
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
