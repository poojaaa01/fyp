import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp/consts/app_constants.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:fyp/widgets/title_text.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FancyShimmerImage(
                    imageUrl: AppConstants.imageUrl,
                    height: size.height*0.2,
                    width: size.height * 0.2,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.6,
                            child: TitlesTextWidget(
                              label: "Title" * 15,
                              maxLines: 2,
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(
                                  IconlyLight.heart,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SubtitleTextWidget(
                              label: "\Rs.1600",
                            color: Colors.blue,
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: (){},
                            icon: const Icon(IconlyLight.arrowDown2),
                            label: const Text("Qty: 1"),
                              style: OutlinedButton.styleFrom(
                                //side: BorderSide(width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),),
                              ),
                          ),
                        ],
                      ),
                  ],
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }
}
