import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/consts/validator.dart';
import 'package:fyp/screens/auth/forgot_password.dart';
import 'package:fyp/screens/auth/register.dart';
import 'package:fyp/screens/mood/mood_log_screen.dart'; // <-- import MoodLogScreen here
import 'package:fyp/widgets/app_name_text.dart';
import 'package:fyp/widgets/auth/google_btn.dart';
import 'package:fyp/widgets/subtitle_text.dart';
import 'package:fyp/widgets/title_text.dart';

import '../../services/app_functions.dart';
import '../loading_manager.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  bool obscureText = true;

  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Fluttertoast.showToast(
          msg: "Login Successful",
          textColor: Colors.white,
        );

        if (!mounted) return;

        // 👇 Redirect to MoodLogScreen after login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MoodLogScreen()),
        );

      } on FirebaseException catch (error) {
        await AppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          fct: () {},
        );
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
  }

  void showFeaturesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "🧭 Moksha Features",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  featureItem(Icons.emoji_emotions, "Mood Tracker"),
                  const Divider(),
                  featureItem(Icons.self_improvement, "Meditation"),
                  const Divider(),
                  featureItem(Icons.shield, "Focus Mode"),
                  const Divider(),
                  featureItem(Icons.groups, "Community Sharing"),
                  const Divider(),
                  featureItem(Icons.stacked_bar_chart, "Progress Analysis"),
                  const Divider(),
                  featureItem(Icons.confirmation_number_outlined, "Book an Appointment"),
                  const Divider(),
                  featureItem(Icons.local_fire_department, "Streak"),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Close"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget featureItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        // Optional: Add actual navigation if you want direct access here too
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60.0),
                  AppNameTextWidget(fontSize: 30),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(label: "Welcome back!!"),
                  ),
                  const SizedBox(height: 16.0),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(IconlyLight.message),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return Validators.emailValidator(value);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          obscureText: obscureText,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "Password",
                            prefixIcon: const Icon(IconlyLight.lock),
                          ),
                          onFieldSubmitted: (value) async {
                            await _loginFct();
                          },
                          validator: (value) {
                            return Validators.passwordValidator(value);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ForgotPasswordScreen.routeName);
                            },
                            child: const SubtitleTextWidget(
                              label: "Forgot password?",
                              fontStyle: FontStyle.italic,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12.0),
                              backgroundColor: Colors.white60,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text("Login"),
                            onPressed: () async {
                              await _loginFct();
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SubtitleTextWidget(
                          label: "Or Just Try These First".toUpperCase(),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: kBottomNavigationBarHeight + 10,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight + 10,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12.0),
                                      backgroundColor: Colors.white60,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    icon: const Icon(Icons.explore),
                                    label: const Text("Explore Moksha"),
                                    onPressed: () {
                                      showFeaturesDialog(context);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight + 10,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12.0),
                                      backgroundColor: Colors.white60,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: const Text("Guest Mode"),
                                    onPressed: () async {
                                      Navigator.of(context).pushNamed('/RootScreen');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SubtitleTextWidget(label: "New here?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routName);
                              },
                              child: const SubtitleTextWidget(
                                label: "Sign up now",
                                fontStyle: FontStyle.italic,
                                textDecoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
