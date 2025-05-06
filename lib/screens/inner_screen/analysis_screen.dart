import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_analysis_provider.dart';
import '../../providers/meditation_analysis_provider.dart';

class AnalysisScreen extends StatelessWidget {
  static const routeName = '/analysis';

  const AnalysisScreen({Key? key}) : super(key: key);

  double _getMaxMeditationDuration(List<Map<String, dynamic>> sessions) {
    if (sessions.isEmpty) return 5.0;
    final maxDuration = sessions
        .map((s) => s['duration'] as int)
        .reduce((a, b) => a > b ? a : b);
    // Convert seconds to minutes for display
    return (maxDuration / 60 * 1.2).toDouble();
  }

  double _getMeditationInterval(List<Map<String, dynamic>> sessions) {
    if (sessions.isEmpty) return 1.0;
    final maxDuration = _getMaxMeditationDuration(sessions);
    if (maxDuration <= 5) return 1.0;
    if (maxDuration <= 10) return 2.0;
    return 5.0;
  }

  Widget _buildAnalysisSection({
    required String title,
    required String description,
    required Widget chart,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        chart,
        const SizedBox(height: 32),
      ],
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case '😊':
        return Colors.green;
      case '😔':
        return Colors.indigo;
      case '😡':
        return Colors.red;
      case '😐':
        return Colors.grey;
      case '😌':
        return Colors.blue;
      case '🥳':
        return Colors.lightGreen;
      case '😰':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodAnalysis = Provider.of<MoodAnalysisProvider>(context);
    final meditationAnalysis = Provider.of<MeditationAnalysisProvider>(context);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset(
            //   AssetsManager.logoApp,
            //   height: 32,
            // ),
            const Text(
              'Check your progress',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
        future: Future.wait([
          moodAnalysis.getMoodDistribution(),
          meditationAnalysis.fetchMeditationSessions(userId),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final moodDistribution = snapshot.data![0] as Map<String, int>;
          debugPrint('Mood Distribution Data: $moodDistribution');

          final meditationSessions = snapshot.data![1] as List<Map<String, dynamic>>;
          final totalMoodEntries = moodDistribution.values.fold(0, (sum, count) => sum + count);
          final totalMeditationSeconds = meditationSessions.fold(0, (sum, session) {
            return sum + (session['duration'] as int? ?? 0);
          });
          final totalMeditationMinutes = (totalMeditationSeconds / 60).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnalysisSection(
                  title: "Mood Distribution",
                  description:
                  "This shows how your moods have been distributed recently. "
                      "You've logged $totalMoodEntries mood entries in total.",
                  chart: AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sections: moodDistribution.entries.map((e) {
                          final percentage = (e.value / totalMoodEntries * 100).round();
                          return PieChartSectionData(
                            value: e.value.toDouble(),
                            title: '${e.key}\n$percentage%',
                            radius: 60,
                            color: _getMoodColor(e.key),
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  context: context,
                ),

                _buildAnalysisSection(
                  title: "Meditation Time",
                  description:
                  "You've meditated for a total of ${totalMeditationMinutes} minutes. "
                      "Regular meditation can help improve mood and reduce stress.",
                  chart: AspectRatio(
                    aspectRatio: 1.7,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 16.0, bottom: 16.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: meditationSessions.map((session) {
                            // Convert seconds to minutes for display
                            final durationMinutes = (session['duration'] as int? ?? 0) / 60;
                            return BarChartGroupData(
                              x: session['xIndex'] as int,
                              barRods: [
                                BarChartRodData(
                                  toY: durationMinutes,
                                  color: Colors.teal,
                                  width: 16,
                                  borderRadius: BorderRadius.circular(4),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: _getMaxMeditationDuration(meditationSessions),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: _getMeditationInterval(meditationSessions),
                                getTitlesWidget: (value, meta) {
                                  // Show minutes with 'min' label
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '${value.toInt()}min',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text('Day ${value.toInt() + 1}'),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: _getMeditationInterval(meditationSessions),
                          ),
                        ),
                      ),
                    ),
                  ),
                  context: context,
                ),

                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Key Takeaways",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("• You've logged $totalMoodEntries mood entries."),
                        const SizedBox(height: 4),
                        if (totalMeditationSeconds > 0)
                          Text("• You've meditated for ${totalMeditationMinutes} minutes this period."),
                        const SizedBox(height: 4),
                        const Text("• Tracking helps you notice patterns and make positive changes."),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}