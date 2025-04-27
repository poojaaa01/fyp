import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/doc_type.dart';
import 'package:fyp/providers/appointment_provider.dart';
import 'package:fyp/providers/recent_activity_provider.dart';
import 'package:fyp/widgets/products/heart_btn.dart';
import 'package:provider/provider.dart';

import '../../screens/inner_screen/doc_details.dart';
import '../../services/app_functions.dart';
import '../subtitle_text.dart';

class PopularDoctorsWidget extends StatelessWidget {
  const PopularDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final docModel = Provider.of<DoctorType>(context);
    final aptProvider = Provider.of<AptProvider>(context);
    final recentActProvider = Provider.of<RecentActivityProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          // Log activity properly with message
          recentActProvider.addDoctorActivity(
            docId: docModel.docId,
            message: 'Viewed ${docModel.docTitle}\'s details',
          );

          await Navigator.pushNamed(
            context,
            DocDetailsScreen.routName,
            arguments: docModel.docId,
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
                    imageUrl: docModel.docImage,
                    height: size.height * 0.2,
                    width: size.height * 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      docModel.docTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5),
                    FittedBox(
                      child: Row(
                        children: [
                          const SizedBox(height: 5),
                          const HeartButtonWidget(),
                          IconButton(
                            onPressed: () async {
                              if (aptProvider.isDocinApt(docId: docModel.docId)) {
                                return;
                              }
                              try {
                                await aptProvider.appointmentFirebase(
                                  docId: docModel.docId,
                                  context: context,
                                );

                                // Log appointment activity here too
                                recentActProvider.addDoctorActivity(
                                  docId: docModel.docId,
                                  message: 'Booked appointment with ${docModel.docTitle}',
                                );

                              } catch (e) {
                                await AppFunctions.showErrorOrWarningDialog(
                                  context: context,
                                  subtitle: e.toString(),
                                  fct: () {},
                                );
                              }
                            },
                            icon: Icon(
                              aptProvider.isDocinApt(docId: docModel.docId)
                                  ? Icons.check
                                  : Icons.shopping_bag_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: docModel.docPrice,
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
