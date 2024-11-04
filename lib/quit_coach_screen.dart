import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class QuitCoachScreen extends StatefulWidget {
  final int yearsSmoking;

  const QuitCoachScreen({
    Key? key,
    required this.yearsSmoking,
  }) : super(key: key);

  @override
  _QuitCoachScreenState createState() => _QuitCoachScreenState();
}

class _QuitCoachScreenState extends State<QuitCoachScreen> {
  DateTime? targetQuitDate;
  int weeklyReductionGoal = 0;
  double goalReduction = 0.2;
  String motivationalMessage = "Set a goal date to start your journey!";
  List<FlSpot> progressData = [];
  int cigarettesPerDay = 0;
  int extraCigarettesToday = 0;

  @override
  void initState() {
    super.initState();
    _initializeProgressData();
  }

  void _initializeProgressData() {
    progressData = List.generate(
      10,
      (i) => FlSpot(i.toDouble(), max(0, cigarettesPerDay - i * 2).toDouble()),
    );
  }

  Future<void> _selectTargetQuitDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.teal,
            surface: Color(0xFF333333),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF1E1E1E),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != targetQuitDate) {
      setState(() {
        targetQuitDate = picked;
        weeklyReductionGoal = _calculateWeeklyReduction();
        progressData = _generateProgressData();
        _updateMotivationalMessage();
      });
    }
  }

  int _calculateWeeklyReduction() {
    if (targetQuitDate == null) return 0;
    final totalWeeks = (targetQuitDate!.difference(DateTime.now()).inDays / 7).ceil();
    return (cigarettesPerDay / totalWeeks).ceil();
  }

  List<FlSpot> _generateProgressData() {
    int currentCigarettesPerDay = cigarettesPerDay + extraCigarettesToday;
    return List.generate(
      10,
      (week) => FlSpot(
        week.toDouble(),
        max(0, currentCigarettesPerDay - (week * weeklyReductionGoal)).toDouble(),
      ),
    );
  }

  void _updateMotivationalMessage() {
    if (targetQuitDate == null) {
      motivationalMessage = "Set a goal date to start your journey!";
    } else {
      final daysUntilQuit = targetQuitDate!.difference(DateTime.now()).inDays;
      motivationalMessage = daysUntilQuit <= 0
          ? "Today is the day! You’ve got this!"
          : daysUntilQuit <= 7
              ? "Almost there, just one more week!"
              : daysUntilQuit <= 30
                  ? "Keep going, you’re halfway there!"
                  : "Every day counts, keep up the progress!";
    }
  }

  void _adjustGoal(double adjustment) {
    setState(() {
      goalReduction = adjustment;
      weeklyReductionGoal = (cigarettesPerDay * goalReduction).ceil();
      progressData = _generateProgressData();
    });
  }

  void _recordExtraCigarette() {
    setState(() {
      extraCigarettesToday++;
      progressData = _generateProgressData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Extra cigarette recorded for today')),
    );
  }

  Widget _buildQuitPlanGraph() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey, strokeWidth: 0.5),
          getDrawingVerticalLine: (value) => FlLine(color: Colors.grey, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('W${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 5,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1),
        ),
        minX: 0,
        maxX: progressData.length.toDouble(),
        minY: 0,
        maxY: (cigarettesPerDay + extraCigarettesToday).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: progressData,
            isCurved: true,
            color: Colors.tealAccent,
            barWidth: 4,
            belowBarData: BarAreaData(show: true, color: Colors.teal.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quit Coach'),
        backgroundColor: const Color(0xFF333333),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectTargetQuitDate(context),
              child: const Text('Select Target Quit Date'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),

            if (targetQuitDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'Target Quit Date: ${DateFormat.yMMMMd().format(targetQuitDate!)}',
                    style: const TextStyle(fontSize: 18, color: Colors.greenAccent),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter cigarettes per day',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  cigarettesPerDay = int.tryParse(value) ?? 0;
                  weeklyReductionGoal = _calculateWeeklyReduction();
                  progressData = _generateProgressData();
                });
              },
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _recordExtraCigarette,
                  child: const Text('Add Extra Cigarette'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(width: 10),
                Text(
                  'Extra today: $extraCigarettesToday',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              motivationalMessage,
              style: const TextStyle(fontSize: 18, color: Colors.greenAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            if (weeklyReductionGoal > 0)
              Text(
                'Reduce by $weeklyReductionGoal cigarettes per week to reach your goal.',
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),

            if (targetQuitDate != null) ...[
              const Text(
                'Your Quitting Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildQuitPlanGraph()),

              Slider(
                value: goalReduction,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                label: "${(goalReduction * 100).toStringAsFixed(0)}% reduction",
                onChanged: (value) => _adjustGoal(value),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
