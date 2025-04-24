import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/doc_type.dart';
import 'package:fyp/screens/inner_screen/doc_details.dart';
import 'package:fyp/widgets/products/heart_btn.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/doc_provider.dart';
import '../title_text.dart';

class DocWidget extends StatefulWidget {
  const DocWidget({
    super.key,
    required this.docId,
  });

  final String docId;

  @override
  State<DocWidget> createState() => _DocWidgetState();
}

class _DocWidgetState extends State<DocWidget> {
  @override
  Widget build(BuildContext context) {
    final docProvider = Provider.of<DocProvider>(context);
    final getCurrDoctor = docProvider.findByDocId(widget.docId);
    final aptProvider = Provider.of<AptProvider>(context);
    final size = MediaQuery.of(context).size;

    if (getCurrDoctor == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50], // Light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              DocDetailsScreen.routName,
              arguments: getCurrDoctor.docId,
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FancyShimmerImage(
                  imageUrl: getCurrDoctor.docImage,
                  height: size.height * 0.22,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(8.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Name and Heart Button
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitlesTextWidget(
                                label: getCurrDoctor.docTitle,
                                fontSize: 18,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                getCurrDoctor.docCategory,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Flexible(flex: 2, child: HeartButtonWidget()),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    // Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SubtitleTextWidget(
                            label: "${getCurrDoctor.docPrice}",
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.circular(12.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              onTap: () {
                                if(aptProvider.isDocinApt(docId: getCurrDoctor.docId)){
                                  return;
                                }
                                aptProvider.addDoctorToAppointment(docId: getCurrDoctor.docId);
                              },
                              splashColor: Colors.yellow,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                    aptProvider.isDocinApt(
                                        docId: getCurrDoctor.docId)
                                        ? Icons.check
                                        : Icons.shopping_bag_outlined),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}