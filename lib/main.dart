import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/providers/appointment_provider.dart';
import 'package:fyp/providers/doc_provider.dart';
import 'package:fyp/providers/mood_provider.dart';
import 'package:fyp/providers/order_provider.dart';
import 'package:fyp/providers/recent_activity_provider.dart';
import 'package:fyp/providers/user_provider.dart';
import 'package:fyp/root_screen.dart';
import 'package:fyp/screens/auth/forgot_password.dart';
import 'package:fyp/screens/auth/login.dart';
import 'package:fyp/screens/auth/register.dart';
import 'package:fyp/screens/inner_screen/doc_details.dart';
import 'package:fyp/screens/inner_screen/orders/orders_screen.dart';
import 'package:fyp/screens/inner_screen/recent_activity.dart';
import 'package:provider/provider.dart';
import 'package:fyp/providers/theme_provider.dart';
import 'consts/theme_data.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter binding is initialized.

  try {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(); // Initialize Firebase
    runApp(const MyApp()); // Run the app after Firebase is initialized.
  } catch (e) {
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: SelectableText(snapshot.error.toString())),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return ThemeProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return DocProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return AptProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return RecentActivityProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return UserProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return OrderProvider();
              },
            ),
            ChangeNotifierProvider(
              create: (_) {
                return MoodProvider();
              },
            ),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Moksha App',
                theme: Styles.themeData(
                  isDarkTheme: themeProvider.getIsDarkTheme,
                  context: context,
                ),
                home: const RootScreen(),
                //home: LoginScreen(),
                routes: {
                  DocDetailsScreen.routName:
                      (context) => const DocDetailsScreen(),
                  RootScreen.routeName: (context) => const RootScreen(),
                  RecentActivityScreen.routName:
                      (context) => const RecentActivityScreen(),
                  RegisterScreen.routName: (context) => const RegisterScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  ForgotPasswordScreen.routeName:
                      (context) => const ForgotPasswordScreen(),
                  OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: SelectableText('Error initializing Firebase!')),
      ),
    );
  }
}
