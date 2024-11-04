import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Import main to access the DashboardScreen after the onboarding journey
import 'package:intl/intl.dart'; // For date formatting

class SmokingJourney extends StatefulWidget {
  final String name;

  const SmokingJourney({Key? key, required this.name}) : super(key: key);

  @override
  _SmokingJourneyState createState() => _SmokingJourneyState();
}

class _SmokingJourneyState extends State<SmokingJourney> {
  DateTime? selectedBirthDate;
  DateTime? selectedSmokingStartDate;
  int age = 0;
  int smokingDays = 0;

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

  // Function to select smoking start date and calculate smoking days
  Future<void> _selectSmokingStartDate(BuildContext context) async {
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
    if (picked != null && picked != selectedSmokingStartDate) {
      setState(() {
        selectedSmokingStartDate = picked;
        smokingDays = DateTime.now().difference(selectedSmokingStartDate!).inDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smoking Journey - Start', style: GoogleFonts.roboto()),
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
                    'images/QSB.jpg',
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

              // Smoking start date selection and days display
              Text(
                'Since when are you smoking?',
                style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _selectSmokingStartDate(context),
                icon: const Icon(Icons.calendar_today),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text(
                  selectedSmokingStartDate == null
                      ? 'Choose Date'
                      : DateFormat.yMMMMd().format(selectedSmokingStartDate!),
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedSmokingStartDate != null)
                Text(
                  'You have been smoking for $smokingDays days.',
                  style: GoogleFonts.roboto(
                      fontSize: 18, color: Colors.greenAccent),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (selectedSmokingStartDate != null && selectedBirthDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmokingJourneyScreen2(
                          name: widget.name,
                          selectedDate: selectedSmokingStartDate!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select your birthdate and smoking start date!'),
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

// Smoking Journey Screen 2
class SmokingJourneyScreen2 extends StatefulWidget {
  final String name;
  final DateTime selectedDate;

  const SmokingJourneyScreen2(
      {Key? key, required this.name, required this.selectedDate})
      : super(key: key);

  @override
  _SmokingJourneyScreen2State createState() => _SmokingJourneyScreen2State();
}

class _SmokingJourneyScreen2State extends State<SmokingJourneyScreen2> {
  final TextEditingController _cigarettesPerDayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smoking Journey - Cigarettes Per Day',
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
                  'images/QSB.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'You’re already taking control! How many cigarettes do you smoke per day?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Text(
              'How many cigarettes do you smoke daily?',
              style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cigarettesPerDayController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Number of cigarettes',
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
                  if (_cigarettesPerDayController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmokingJourneyScreen3(
                          name: widget.name,
                          selectedDate: widget.selectedDate,
                          cigarettesPerDay: int.parse(_cigarettesPerDayController.text),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter the number of cigarettes!'),
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

// Smoking Journey Screen 3
class SmokingJourneyScreen3 extends StatefulWidget {
  final String name;
  final DateTime selectedDate;
  final int cigarettesPerDay;

  const SmokingJourneyScreen3({
    Key? key,
    required this.name,
    required this.selectedDate,
    required this.cigarettesPerDay,
  }) : super(key: key);

  @override
  _SmokingJourneyScreen3State createState() => _SmokingJourneyScreen3State();
}

class _SmokingJourneyScreen3State extends State<SmokingJourneyScreen3> {
  final TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Smoking Journey - Cost of Pack', style: GoogleFonts.roboto()),
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
                  'images/QSB.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'You’re almost there! How much does each pack of cigarettes cost?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Text(
              'How much does a pack of cigarettes cost?',
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
                        startDate: widget.selectedDate,
                        cigarettesInPack: 20,
                        cigarettesPerDay: widget.cigarettesPerDay,
                        costPerPack: cost ?? 0.0,
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
