import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fyp/widgets/empty_apt.dart';
import 'package:fyp/widgets/subtitle_text.dart';

import '../services/assets_manager.dart';
import '../widgets/title_text.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: EmptyAptWidget(
          imagePath: AssetsManager.noApt,
          title: "No appointment scheduled...",
          subtitle: "Want to set one?",
          buttonText: "Book an Appointment")
      );
  }
}
