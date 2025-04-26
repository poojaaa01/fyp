import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fyp/consts/app_constants.dart';
import 'package:fyp/services/assets_manager.dart';
import 'package:fyp/widgets/app_name_text.dart';
import 'package:fyp/widgets/products/popular_doc.dart';
import 'package:fyp/widgets/products/start_rounded_widget.dart';
import 'package:fyp/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:fyp/providers/theme_provider.dart';
import 'package:fyp/providers/doc_provider.dart';
import 'package:fyp/screens/mood/mood_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final docProvider = Provider.of<DocProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoApp),
        ),
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.amber,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: docProvider.getDoctors.isNotEmpty,
                child: const TitlesTextWidget(label: "Popular Doctors"),
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: docProvider.getDoctors.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docProvider.getDoctors.length < 10
                        ? docProvider.getDoctors.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: docProvider.getDoctors[index],
                        child: const PopularDoctorsWidget(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const TitlesTextWidget(label: "Start Your Journey"),
              const SizedBox(height: 15.0),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(AppConstants.startList.length, (index) {
                  final feature = AppConstants.startList[index];
                  return GestureDetector(
                    onTap: () {
                      if (feature.name == "Mood Tracker") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodTrackerScreen(),
                          ),
                        );
                      } else {
                        debugPrint("${feature.name} tapped!");
                      }
                    },
                    child: StartRoundedWidget(
                      image: feature.image,
                      name: feature.name,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
