import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'your_cigarette_manager.dart'; 
import 'package:intl/intl.dart';

class ProcessScreen extends StatelessWidget {
  final YourCigaretteManager cigaretteManager;
  final List<Map<String, dynamic>> htimes;
  final String lang;

  const ProcessScreen({
    Key? key,
    required this.cigaretteManager,
    required this.htimes,
    required this.lang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration passedDuration = cigaretteManager.calculatePassedTime();
    double totalDurationInDays = htimes.fold(0, (total, time) => total + time["time"].inDays.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quitting Process',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF333333),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journey to Quit Smoking',
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimePassedText(passedDuration),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: htimes.length,
                itemBuilder: (context, index) {
                  double progress = passedDuration.inDays / htimes[index]["time"].inDays;
                  return _buildTimeCard(htimes[index], progress, context);
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _getEncouragementMessage(passedDuration, totalDurationInDays),
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePassedText(Duration passedDuration) {
    return Text(
      'Time Passed: ${passedDuration.inDays} days',
      style: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTimeCard(Map<String, dynamic> timeData, double progress, BuildContext context) {
    DateTime targetDate = DateTime.now().add(timeData["time"]);
    final milestoneDate = DateFormat.yMMMMd().format(targetDate);

    return Card(
      color: const Color(0xFF444444),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milestone: ${timeData["time"].inDays} days ($milestoneDate)',
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: progress > 1 ? 1 : progress),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                        minHeight: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (progress >= 1)
              Text(
                'Milestone reached!',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.greenAccent),
              ),
          ],
        ),
      ),
    );
  }

  String _getEncouragementMessage(Duration passedDuration, double totalDurationInDays) {
    double progress = passedDuration.inDays / totalDurationInDays;
    if (progress >= 1) {
      return "Congratulations! You've completed your quitting journey!";
    } else if (progress >= 0.75) {
      return "Almost there! Stay strong, you're in the final stretch!";
    } else if (progress >= 0.5) {
      return "You're halfway through! Keep up the great work!";
    } else if (progress >= 0.25) {
      return "Great start! You've made significant progress!";
    } else {
      return "Just starting out? Every day counts, keep going!";
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Returning to the previous screen.")),
              );
            },
            icon: const Icon(Icons.arrow_back),
            label: Text(
              'Go Back',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.grey,
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Progress Confirmed! Keep going!")),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: Text(
              'Confirm',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
