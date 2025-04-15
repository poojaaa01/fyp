import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp/screens/inner_screen/recent_activity.dart';
import 'package:fyp/services/app_functions.dart';
import 'package:fyp/services/assets_manager.dart';
import 'package:fyp/widgets/app_name_text.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/title_text.dart';
import 'auth/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoApp),
        ),
        title: AppNameTextWidget(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: TitlesTextWidget(label: "Please login to have access"),
              ),
            ),
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Colors.deepPurple, width: 3),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TitlesTextWidget(label: "Pooja Pantha"),
                        SizedBox(height: 6),
                        SubtitleTextWidget(label: "panthapooja5@gmail.com"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 2),
                  const TitlesTextWidget(label: "General"),
                  const SizedBox(height: 10),
                  CustomListTile(
                    text: "Recent Activity",
                    imagePath: AssetsManager.activity,
                    function: () {
                      Navigator.pushNamed(
                        context,
                        RecentActivityScreen.routName,
                      );
                    },
                  ),
                  CustomListTile(
                    text: "Streaks",
                    imagePath: AssetsManager.progress,
                    function: () {},
                  ),
                  CustomListTile(
                    text: "Set a reminder",
                    imagePath: AssetsManager.reminder,
                    function: () {},
                  ),
                  CustomListTile(
                    text: "Analysis",
                    imagePath: AssetsManager.analysis,
                    function: () {},
                  ),
                  const SizedBox(height: 6),
                  const Divider(thickness: 2),
                  const TitlesTextWidget(label: "Settings"),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    secondary: Image.asset(
                      themeProvider.getIsDarkTheme
                          ? AssetsManager.dark
                          : AssetsManager.light,
                      height: 34,
                    ),
                    title: Text(
                      themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode",
                    ),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                  const Divider(thickness: 2),
                  const TitlesTextWidget(label: "Others"),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                icon: const Icon(Icons.login),
                label: const Text("Log Out"),
                onPressed: () async {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                  //await AppFunctions.showErrorOrWarningDialog(
                      //context: context, subtitle: "Are you sure you want to sign out?",
                      //fct: (){},
                    //isError: false,
                  //);
                },
              ),
            ),
          ],
         ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(imagePath, height: 35),
      trailing: Icon(IconlyLight.arrowRight2),
    );
  }
}
