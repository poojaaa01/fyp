import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp/widgets/products/heart_btn.dart';
import 'package:fyp/widgets/title_text.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/doc_provider.dart';
import '../../services/app_functions.dart';
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
    final docProvider = Provider.of<DocProvider>(context);
    String? docId = ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrDoctor = docProvider.findByDocId(docId!);
    final aptProvider = Provider.of<AptProvider>(context);
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
      body: getCurrDoctor == null ? const SizedBox.shrink(): SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: getCurrDoctor.docImage,
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
                          getCurrDoctor.docTitle,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SubtitleTextWidget(
                        label: getCurrDoctor.docPrice,
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
                        HeartButtonWidget(bkgColor: Colors.blue.shade100),
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
                              onPressed: () async{
                                try {await
                                aptProvider.appointmentFirebase(docId: getCurrDoctor.docId, context: context);
                                }
                                catch(e){
                                  await AppFunctions.showErrorOrWarningDialog(
                                    context: context,
                                    subtitle: e.toString(),
                                    fct: () {},
                                  );
                                }
                              },
                              icon: Icon(aptProvider.isDocinApt(
                                  docId: getCurrDoctor.docId)
                                  ? Icons.check
                                  : Icons.shopping_bag_outlined),
                              label: Text(aptProvider.isDocinApt(
                                  docId: getCurrDoctor.docId)
                                  ?"Finalize your appointment" :"Make an appointment"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitlesTextWidget(label: "About the Doctor"),
                        SubtitleTextWidget(label: getCurrDoctor.docCategory)
                      ]),
                  const SizedBox(height: 15),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getCurrDoctor.docDescription,
                        textAlign: TextAlign.justify, // This makes the text justified
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5, // Line height
                        ),
                      ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
