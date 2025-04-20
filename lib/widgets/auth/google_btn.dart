import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

import '../../root_screen.dart';
import '../../services/app_functions.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    try {
      // Force show account picker by signing out first
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        print('Google Sign-In cancelled');
        return;
      }

      final googleAuth = await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      if(authResult.additionalUserInfo!.isNewUser){
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid)
            .set({
          'userId': authResult.user!.uid,
          'userName': authResult.user!.displayName,
          'userImage': authResult.user!.photoURL,
          'userEmail': authResult.user!.email,
          'createdAt': Timestamp.now(),
          'userAppointment': [],
        });
      }

      if (authResult.user != null) {
        print("Google Sign-In success: ${authResult.user?.email}");

        // Navigate to the root screen
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, RootScreen.routeName);
        }
      } else {
        print("Google Sign-In returned null user.");
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.message ?? "Unknown FirebaseAuth error",
        fct: () {},
      );
    } catch (e) {
      print("Error during Google Sign-In: $e");
      await AppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.white60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      icon: const Icon(Ionicons.logo_google, color: Colors.red),
      label: const Text(
        "Sign in with Google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        await _googleSignIn(context: context);
      },
    );
  }
}
