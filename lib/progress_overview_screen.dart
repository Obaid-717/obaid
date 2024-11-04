import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for text styling

class ProgressOverviewScreen extends StatelessWidget {
  final String smokeFreeTime;
  final String moneySaved;
  final String lifeRegained;
  final int cigarettesNotSmoked;

  const ProgressOverviewScreen({
    Key? key,
    required this.smokeFreeTime,
    required this.moneySaved,
    required this.lifeRegained,
    required this.cigarettesNotSmoked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress Overview',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Centered circular progress bar
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.7, // Example progress value (70%)
                      strokeWidth: 8.0,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.teal),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const Icon(
                    Icons.refresh,
                    size: 50,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Progress details in 2x2 grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildProgressTile(
                    icon: Icons.flag,
                    title: 'Smoke Free',
                    value: smokeFreeTime,
                    valueColor: Colors.red,
                  ),
                  _buildProgressTile(
                    icon: Icons.monetization_on,
                    title: 'Money Saved',
                    value: moneySaved,
                    valueColor: Colors.green,
                  ),
                  _buildProgressTile(
                    icon: Icons.access_time,
                    title: 'Life Regained',
                    value: lifeRegained,
                    valueColor: Colors.orange,
                  ),
                  _buildProgressTile(
                    icon: Icons.smoke_free,
                    title: 'Cigarettes Not Smoked',
                    value: cigarettesNotSmoked.toString(),
                    valueColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a tile with an icon and progress information
  Widget _buildProgressTile({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.teal,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
