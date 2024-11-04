import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'package:intl/intl.dart'; // For date formatting

class VapingJourney extends StatefulWidget {
  final String name;

  const VapingJourney({Key? key, required this.name}) : super(key: key);

  @override
  _VapingJourneyState createState() => _VapingJourneyState();
}

class _VapingJourneyState extends State<VapingJourney> {
  DateTime? selectedBirthDate;
  DateTime? selectedVapingStartDate;
  int age = 0;
  int vapingDays = 0;

  // Function to select birthdate and calculate age
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 25)), // Default to 25 years old
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.teal,
              surface: Color(0xFF333333),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
        age = DateTime.now().year - selectedBirthDate!.year;
        if (DateTime.now().month < selectedBirthDate!.month ||
            (DateTime.now().month == selectedBirthDate!.month &&
                DateTime.now().day < selectedBirthDate!.day)) {
          age--;
        }
      });
    }
  }

  // Function to select vaping start date and calculate vaping days
  Future<void> _selectVapingStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.teal,
              surface: Color(0xFF333333),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedVapingStartDate) {
      setState(() {
        selectedVapingStartDate = picked;
        vapingDays = DateTime.now().difference(selectedVapingStartDate!).inDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaping Journey - Start', style: GoogleFonts.roboto()),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const StepIndicator(currentStep: 1, totalSteps: 3),
              const SizedBox(height: 20),

              // Expanded image section
              Expanded(
                child: Center(
                  child: Image.asset(
                    'images/QV.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'You are making a life-changing decision! Let\'s get started!',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Birthdate selection and age display
              Text('Select your Birthdate',
                  style: GoogleFonts.roboto(fontSize: 22, color: Colors.white)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _selectBirthDate(context),
                icon: const Icon(Icons.calendar_today),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text(
                  selectedBirthDate == null
                      ? 'Choose Date'
                      : DateFormat.yMMMMd().format(selectedBirthDate!),
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedBirthDate != null)
                Text(
                  'You are $age years old.',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              const SizedBox(height: 20),

              // Vaping start date selection and days display
              Text(
                'Since when were you vaping?',
                style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _selectVapingStartDate(context),
                icon: const Icon(Icons.calendar_today),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text(
                  selectedVapingStartDate == null
                      ? 'Choose Date'
                      : DateFormat.yMMMMd().format(selectedVapingStartDate!),
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedVapingStartDate != null)
                Text(
                  'You have been vaping for $vapingDays days.',
                  style: GoogleFonts.roboto(
                      fontSize: 18, color: Colors.greenAccent),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (selectedVapingStartDate != null && selectedBirthDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VapingJourneyScreen2(
                          name: widget.name,
                          vapingDays: vapingDays,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select your birthdate and vaping start date!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text('Next', style: GoogleFonts.roboto(fontSize: 18)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Vaping Journey Screen 2
class VapingJourneyScreen2 extends StatefulWidget {
  final String name;
  final int vapingDays;

  const VapingJourneyScreen2({Key? key, required this.name, required this.vapingDays})
      : super(key: key);

  @override
  _VapingJourneyScreen2State createState() => _VapingJourneyScreen2State();
}

class _VapingJourneyScreen2State extends State<VapingJourneyScreen2> {
  final TextEditingController _vapesPerWeekController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaping Journey - Vapes Per Week',
            style: GoogleFonts.roboto()),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepIndicator(currentStep: 2, totalSteps: 3),
            const SizedBox(height: 20),

            // Expanded image section
            Expanded(
              child: Center(
                child: Image.asset(
                  'images/QV.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'You’re already taking control! How many vapes do you use per week?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Text(
              'How many disposable vapes do you use weekly?',
              style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _vapesPerWeekController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Number of vapes',
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.grey[800],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_vapesPerWeekController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VapingJourneyScreen3(
                          name: widget.name,
                          vapingDays: widget.vapingDays,
                          vapesPerWeek: int.parse(_vapesPerWeekController.text),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter the number of vapes!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text('Next', style: GoogleFonts.roboto(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Vaping Journey Screen 3
class VapingJourneyScreen3 extends StatefulWidget {
  final String name;
  final int vapingDays;
  final int vapesPerWeek;

  const VapingJourneyScreen3({
    Key? key,
    required this.name,
    required this.vapingDays,
    required this.vapesPerWeek,
  }) : super(key: key);

  @override
  _VapingJourneyScreen3State createState() => _VapingJourneyScreen3State();
}

class _VapingJourneyScreen3State extends State<VapingJourneyScreen3> {
  final TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Vaping Journey - Cost Per Week', style: GoogleFonts.roboto()),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepIndicator(currentStep: 3, totalSteps: 3),
            const SizedBox(height: 20),

            // Expanded image section
            Expanded(
              child: Center(
                child: Image.asset(
                  'images/QV.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'You’re almost there! How much does vaping cost you weekly?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Text(
              'How much does vaping cost you per week?',
              style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cost in SAR',
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.grey[800],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  double? cost;
                  try {
                    cost = double.parse(_costController.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid cost!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                        name: widget.name,
                        startDate: DateTime.now().subtract(Duration(days: widget.vapingDays)),
                        cigarettesInPack: 1, // Not applicable to vapes
                        cigarettesPerDay: widget.vapesPerWeek, // Vapes per week
                        costPerPack: cost ?? 0.0, // Cost entered by the user
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text('I Can and I Will Quit!',
                    style: GoogleFonts.roboto(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Step Indicator Widget to show current step in the process
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator(
      {Key? key, required this.currentStep, required this.totalSteps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: index < currentStep ? Colors.teal : Colors.grey[600],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
