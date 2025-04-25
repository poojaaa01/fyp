import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp/screens/inner_screen/orders/orders_screen.dart';
import 'package:fyp/screens/inner_screen/recent_activity.dart';
import 'package:fyp/screens/loading_manager.dart';
import 'package:fyp/services/app_functions.dart';
import 'package:fyp/services/assets_manager.dart';
import 'package:fyp/widgets/app_name_text.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/title_text.dart';
import 'auth/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;

  UserModel? userModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoApp),
        ),
        title: AppNameTextWidget(),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: user == null ? true : false,
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: TitlesTextWidget(label: "Please login to have access"),
                ),
              ),
              userModel == null
                  ? const SizedBox.shrink()
                  : Padding(
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
                        color: Theme
                            .of(context)
                            .cardColor,
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(userModel!.userImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitlesTextWidget(label: userModel!.userName),
                        SizedBox(height: 6),
                        SubtitleTextWidget(label: userModel!.userEmail),
                      ],
                    ),
                  ],
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
                      text: "Recent activity",
                      imagePath: AssetsManager.activity,
                      function: () {
                        Navigator.pushNamed(
                          context,
                          RecentActivityScreen.routName,
                        );
                      },
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Streaks",
                        imagePath: AssetsManager.progress,
                        function: () {},
                      ),
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Ongoing appointment",
                        imagePath: AssetsManager.Onapt,
                        function: () {
                          Navigator.pushNamed(
                            context,
                            OrdersScreenFree.routeName,
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Set a reminder",
                        imagePath: AssetsManager.reminder,
                        function: () {},
                      ),
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        text: "Analysis",
                        imagePath: AssetsManager.analysis,
                        function: () {},
                      ),
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
                        themeProvider.getIsDarkTheme
                            ? "Dark Mode"
                            : "Light Mode",
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
                  icon: Icon(user == null ? Icons.login : Icons.logout),
                  label: Text(user == null ? "Login" : "Log Out"),
                  onPressed: () async {
                    await AppFunctions.showErrorOrWarningDialog(
                      context: context,
                      subtitle: "Are you sure you want to sign out?",
                      fct: () async {
                        await FirebaseAuth.instance.signOut();
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      },
                      isError: false,
                    );
                  },
                ),
              ),
            ],
          ),
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
