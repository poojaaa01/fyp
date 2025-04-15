import 'package:flutter/material.dart';
import 'package:fyp/root_screen.dart';
import 'package:fyp/screens/auth/login.dart';
import 'package:fyp/screens/auth/register.dart';
import 'package:fyp/screens/inner_screen/doc_details.dart';
import 'package:fyp/screens/inner_screen/recent_activity.dart';
import 'package:provider/provider.dart';
import 'package:fyp/providers/theme_provider.dart';
import 'consts/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Moksha App',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const RootScreen(),
            //home: LoginScreen(),
            routes: {
              DocDetailsScreen.routName: (context) => const DocDetailsScreen(),
              RootScreen.routeName: (context) => const RootScreen(),
              RecentActivityScreen.routName: (context) => const RecentActivityScreen(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
              LoginScreen.routeName: (context) => const LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
