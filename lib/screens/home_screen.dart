import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fyp/consts/app_constants.dart';
import 'package:fyp/screens/Community/community_screen.dart';
import 'package:fyp/screens/calm/calm_screen.dart';
import 'package:fyp/services/assets_manager.dart';
import 'package:fyp/widgets/app_name_text.dart';
import 'package:fyp/widgets/products/popular_doc.dart';
import 'package:fyp/widgets/products/start_rounded_widget.dart';
import 'package:fyp/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:fyp/providers/theme_provider.dart';
import 'package:fyp/providers/doc_provider.dart';
import 'package:fyp/providers/user_provider.dart';
import 'package:fyp/screens/mood/mood_tracker_screen.dart';
import 'package:fyp/screens/focus/focus_mode_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final docProvider = Provider.of<DocProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

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
                        if (userProvider.userModel == null) {
                          _showLoginRequiredDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoodTrackerScreen(),
                            ),
                          );
                        }
                      } else if (feature.name == "Focus Mode") {
                        if (userProvider.userModel == null) {
                          _showLoginRequiredDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FocusModeScreen(),
                            ),
                          );
                        }
                      } else if (feature.name == "Community") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommunityScreen(),
                          ),
                        );
                      }
                      else if (feature.name == "Calm") {
                        if (userProvider.userModel == null) {
                          _showLoginRequiredDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalmMainScreen(),
                            ),
                          );
                        }
                      }
                      else {
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

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please login to access this feature."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
