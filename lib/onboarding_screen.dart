import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom text styling
import 'smokingjourney.dart'; // Ensure correct reference
import 'vapingjourney.dart'; // Ensure correct reference

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  _OnboardingScreen1State createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedOption = 'smoking'; // Default option (Smoking selected)
  double _opacity = 0.0; // Variable for opacity animation

  // Selected quitting reason
  String _selectedReason = 'Select your reason for quitting';
  String? _selectedGender; // Gender selection
  final List<String> _reasons = [
    'To improve overall health and well-being.',
    'To reduce the risk of lung cancer and other cancers.',
    'To breathe easier and enhance lung function.',
    'To save money that would otherwise be spent on cigarettes.',
    'To set a positive example for children and loved ones.'
  ];

  @override
  void initState() {
    super.initState();
    // Fade in the image and button on page load
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Function to show reason selection dialog and update the reason on selection
  Future<void> _showReasonDialog() async {
    String? selectedReason = _selectedReason;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Reason for Quitting"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _reasons.map((reason) {
                  return RadioListTile<String>(
                    title: Text(reason),
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Done"),
                onPressed: () {
                  if (selectedReason != null) {
                    setState(() {
                      _selectedReason = selectedReason!;
                    });
                    this.setState(() {}); // Update main screen
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  // Function to show gender picker dialog
  Future<void> _showGenderPicker() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Gender"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text("Male"),
                onTap: () {
                  setState(() {
                    _selectedGender = "Male";
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Female"),
                onTap: () {
                  setState(() {
                    _selectedGender = "Female";
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("I prefer not to say"),
                onTap: () {
                  setState(() {
                    _selectedGender = "I prefer not to say";
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to validate form inputs
  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter your name');
      return false;
    }
    if (_selectedGender == null) {
      _showSnackBar('Please select your gender');
      return false;
    }
    return true;
  }

  // Helper method to show a SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome!',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Four images displayed in a 2x2 grid
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1000),
                child: GridView.count(
                  crossAxisCount: 2, // Two images per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true, // Important to allow GridView inside Column
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildImageTile('images/welcome_illustration.png'),
                    _buildImageTile('images/image4.png'),
                    _buildImageTile('images/image50.png'),
                    _buildImageTile('images/image40.png'),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Name and Gender selection combined
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _showGenderPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedGender ?? "Gender",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reason for Quitting Dropdown
              GestureDetector(
                onTap: _showReasonDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedReason,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Question for smoking or vaping
              Text(
                'Do you smoke or vape?',
                style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 10),

              // Radio buttons for Smoking and Vaping options
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text(
                        'Smoking',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'smoking',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text(
                        'Vaping',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'vaping',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action button
              Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 1000),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_validateInputs()) {
                        if (_selectedOption == 'smoking') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SmokingJourney(name: _nameController.text),
                            ),
                          );
                        } else if (_selectedOption == 'vaping') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VapingJourney(name: _nameController.text),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text(
                      'Next',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build an image tile with styling
  Widget _buildImageTile(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
