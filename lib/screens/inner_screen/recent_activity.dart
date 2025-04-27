import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recent_activity_provider.dart';
import '../../services/app_functions.dart';
import '../../services/assets_manager.dart';
import '../../widgets/products/doc_widget.dart';
import '../../widgets/title_text.dart';
import '../../widgets/empty_apt.dart';

class RecentActivityScreen extends StatelessWidget {
  static const routName = "/RecentActivityScreen";

  const RecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recentActProvider = Provider.of<RecentActivityProvider>(context);

    return recentActProvider.getRecentActivities.isEmpty
        ? Scaffold(
      body: EmptyAptWidget(
        imagePath: AssetsManager.noApt,
        title: "No activity detected",
        subtitle: "Want to set one?",
        buttonText: "Start an Activity",
      ),
    )
        : Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoApp),
        ),
        title: const TitlesTextWidget(label: "Recent Activity"),
        actions: [
          IconButton(
            onPressed: () {
              AppFunctions.showErrorOrWarningDialog(
                isError: false,
                context: context,
                subtitle: "Are you sure you want to clear all activities?",
                fct: () {
                  recentActProvider.clearRecentActivities();
                },
              );
            },
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: DynamicHeightGridView(
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        builder: (context, index) {
          final activity = recentActProvider.getRecentActivities[index];

          if (activity.activityType == 'doctor') {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DocWidget(docId: activity.docId!),
            );
          } else {
            // For mood and focus activity types
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: activity.activityType == 'mood'
                    ? Colors.blueAccent
                    : Colors.blueGrey,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    activity.message,
                    style: const TextStyle(
                        //color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    timeAgo(activity.timestamp),
                    style: const TextStyle(color: Colors.white60),
                  ),
                ),
              ),
            );
          }
        },
        itemCount: recentActProvider.getRecentActivities.length,
        crossAxisCount: 1,
      ),
    );
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}
