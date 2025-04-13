import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp/widgets/title_text.dart';

import '../../consts/app_constants.dart';
import '../../services/assets_manager.dart';
import '../../widgets/app_name_text.dart';
import '../../widgets/subtitle_text.dart';

class DocDetailsScreen extends StatefulWidget {
  static const routName = "/DocDetailsScreen";

  const DocDetailsScreen({super.key});

  @override
  State<DocDetailsScreen> createState() => _DocDetailsScreenState();
}

class _DocDetailsScreenState extends State<DocDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            //Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: AppConstants.imageUrl,
              height: size.height * 0.38,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Title" * 18,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SubtitleTextWidget(
                        label: "\Rs. 1550",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(elevation: 10),
                            onPressed: () {},
                            icon: Icon(IconlyLight.heart),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.shopping_bag),
                              label: const Text("Make an appointment"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [TitlesTextWidget(label: "About the Doctor")]),
                  const SizedBox(height: 15),
                  SubtitleTextWidget(label: "Description"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
