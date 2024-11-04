import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // For downloading the PDF on web
import 'package:intl/intl.dart'; // For formatting dates
import 'package:google_fonts/google_fonts.dart'; // For better typography
import 'package:csv/csv.dart'; // For CSV export
import 'package:fl_chart/fl_chart.dart'; // For charts
import 'dart:convert';


class WalletScreen extends StatefulWidget {
  final double moneySaved;
  final DateTime quitDate;
  double totalCost;

  WalletScreen({
    Key? key,
    required this.moneySaved,
    required this.quitDate,
    required this.totalCost,
  }) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late List<Map<String, dynamic>> savingsEntries;

  @override
  void initState() {
    super.initState();
    savingsEntries = _generateSavingsEntries(); // Generate the initial savings entries
  }

  // Function to generate savings entries based on milestones (weekly savings)
  List<Map<String, dynamic>> _generateSavingsEntries() {
    List<Map<String, dynamic>> entries = [];
    double amount = 100.0; // Example starting savings for each milestone
    DateTime currentDate = widget.quitDate;
    for (int i = 1; i <= 4; i++) {
      // Generate 4 entries for simplicity
      currentDate = currentDate.add(Duration(days: 7 * i));
      String formattedDate = DateFormat.yMMMMEEEEd().format(currentDate);
      entries.add({"date": formattedDate, "amount": amount});
      amount += 50.0; // Increment the savings amount
    }
    return entries;
  }

  // Function to show a dialog for customizing savings goals
  void _showGoalDialog(BuildContext context) {
    TextEditingController goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Customize Savings Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "Enter your savings goal (SAR)"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (goalController.text.isNotEmpty) {
                  setState(() {
                    double customGoal = double.parse(goalController.text);
                    widget.totalCost =
                        customGoal; // Update the total goal to a custom value
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to export the savings data as CSV
  void _exportToCSV(List<Map<String, dynamic>> savingsEntries) {
    List<List<dynamic>> rows = [];
    rows.add(["Date", "Amount"]);

    for (var entry in savingsEntries) {
      rows.add([entry["date"], entry["amount"]]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      // For web: trigger a download via an AnchorElement
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "savings_data.csv")
        ..click();
      html.Url.revokeObjectUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV downloaded successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV export is only supported on web.')),
      );
    }
  }

  // Function to save the PDF and show a notification
  Future<void> _savePdfWithNotification() async {
    final pdf = await _generatePdfReport(savingsEntries, widget.moneySaved);

    if (kIsWeb) {
      // Web: download the PDF directly in the browser
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'savings_report.pdf');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF downloaded')),
      );
    }
  }

  // Build an improved line chart for savings progress
  Widget _buildImprovedSavingsChart(List<Map<String, dynamic>> savingsEntries) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 50,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey,
              strokeWidth: 0.8,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey,
              strokeWidth: 0.8,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final int index = value.toInt();
                if (index >= 0 && index < savingsEntries.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      savingsEntries[index]['date'].toString().split(',')[0],
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  );
                }
                return Container();
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'SAR ${value.toInt()}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                );
              },
              interval: 50,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1),
        ),
        minX: 0,
        maxX: (savingsEntries.length - 1).toDouble(),
        minY: 0,
        maxY: 300,
        lineBarsData: [
          LineChartBarData(
            spots: savingsEntries.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value["amount"]);
            }).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.greenAccent, Colors.green],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.green,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: const LinearGradient(
                colors: [
                  Colors.greenAccent,
                  Colors.green,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 150,
              color: Colors.redAccent,
              strokeWidth: 2,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                labelResolver: (line) => 'Goal',
                style: const TextStyle(color: Colors.red, fontSize: 12),
                alignment: Alignment.topRight,
              ),
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8.0),
            tooltipMargin: 8,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final date = savingsEntries[touchedSpot.x.toInt()]['date'];
                final amount = touchedSpot.y.toStringAsFixed(2);
                return LineTooltipItem(
                  'Date: $date\nSaved: SAR $amount',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.moneySaved / widget.totalCost;
    progress = progress > 1 ? 1 : progress; // Ensure the progress value doesn't exceed 1

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf), // PDF icon
            onPressed: _savePdfWithNotification, // Call the function here
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.green[400],
            child: Column(
              children: [
                Text(
                  'Balance',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SAR ${widget.moneySaved.toStringAsFixed(2)}',
                  style: GoogleFonts.roboto(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                Text(
                  'You have saved ${progress * 100} % of your goal!',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildImprovedSavingsChart(savingsEntries),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savingsEntries.length,
              itemBuilder: (context, index) {
                final entry = savingsEntries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 3,
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green[700],
                      ),
                      title: Text(
                        entry["date"],
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        'SAR ${entry["amount"].toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _exportToCSV(savingsEntries),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.download),
      ),
    );
  }

  Future<pw.Document> _generatePdfReport(
    List<Map<String, dynamic>> entries,
    double totalSavings,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Savings Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Savings: SAR ${totalSavings.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Savings Breakdown:', style: pw.TextStyle(fontSize: 18)),
              pw.ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(entry["date"], style: pw.TextStyle(fontSize: 16)),
                        pw.Text('SAR ${entry["amount"].toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}
