// main.dart
import 'package:flutter/material.dart';
import 'process_screen.dart';
import 'wallet_screen.dart';
import 'your_cigarette_manager.dart';
import 'library_screen.dart';
import 'onboarding_screen.dart';
import 'quit_coach_screen.dart';
import 'progress_screen.dart';
import 'notifications_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(QuitSmokingApp());
}

class QuitSmokingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quit Smoking App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primaryColor: const Color(0xFF333333),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BFA5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen1(),
        '/dashboard': (context) => DashboardScreen(
              name: 'User',
              startDate: DateTime.now(),
              cigarettesInPack: 20,
              cigarettesPerDay: 10,
              costPerPack: 15.0,
            ),
        '/process': (context) => ProcessScreen(
              cigaretteManager: YourCigaretteManager(),
              htimes: [],
              lang: 'en',
            ),
        '/wallet': (context) => WalletScreen(
              moneySaved: 500.0,
              quitDate: DateTime.now(),
              totalCost: 1000.0,
            ),
        '/library': (context) => const LibraryScreen(),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String name;
  final DateTime startDate;
  final int cigarettesInPack;
  final int cigarettesPerDay;
  final double costPerPack;

  const DashboardScreen({
    Key? key,
    required this.name,
    required this.startDate,
    required this.cigarettesInPack,
    required this.cigarettesPerDay,
    required this.costPerPack,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> notifications = ["Welcome to Quit Smoking App!"];
  double moneyWasted = 0.0;
  int cigarettesNotSmoked = 0;
  Duration smokeFreeDuration = const Duration(seconds: 0);
  late Timer timer;
  static const int goalDays = 360;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    moneyWasted = _calculateMoneyWasted();
    cigarettesNotSmoked = _calculateCigarettesNotSmoked();
    _startSmokeFreeTimer();
    _saveData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        notifications.add("Welcome back, ${widget.name}! Keep up the good work.");
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', widget.name);
    await prefs.setString('startDate', widget.startDate.toString());
    await prefs.setInt('cigarettesInPack', widget.cigarettesInPack);
    await prefs.setInt('cigarettesPerDay', widget.cigarettesPerDay);
    await prefs.setDouble('costPerPack', widget.costPerPack);
  }

  int _calculateDaysPassed() {
    final now = DateTime.now();
    return now.difference(widget.startDate).inDays;
  }

  double _calculateMoneyWasted() {
    int daysPassed = _calculateDaysPassed();
    return (widget.cigarettesPerDay / widget.cigarettesInPack) *
        widget.costPerPack *
        daysPassed;
  }

  int _calculateCigarettesNotSmoked() {
    int daysPassed = _calculateDaysPassed();
    return widget.cigarettesPerDay * daysPassed;
  }

  void _startSmokeFreeTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        smokeFreeDuration = Duration(seconds: smokeFreeDuration.inSeconds + 1);
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuitCoachScreen(
            yearsSmoking: _calculateYearsSmoking(),
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProgressScreen()));
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/library');
    }
  }

  int _calculateYearsSmoking() {
    final now = DateTime.now();
    final smokingStartDate = widget.startDate;
    int yearsSmoking = now.year - smokingStartDate.year;
    if (now.month < smokingStartDate.month ||
        (now.month == smokingStartDate.month && now.day < smokingStartDate.day)) {
      yearsSmoking--;
    }
    return yearsSmoking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF333333),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(
                    notifications: notifications,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.name}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have been smoke-free since ${widget.startDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: (_calculateDaysPassed() / goalDays).clamp(0.0, 1.0),
                          strokeWidth: 12.0,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Text(
                        '${_calculateDaysPassed()}/$goalDays',
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Day Completion Indicator',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'You are stronger than you think :)',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildProgressCard("Smoke Free", _formatDuration(smokeFreeDuration), Icons.flag),
                    _buildProgressCard("Money Wasted", "SAR ${moneyWasted.toStringAsFixed(2)}", Icons.monetization_on),
                    _buildProgressCard("Cigarettes Per Day", "${widget.cigarettesPerDay}", Icons.smoking_rooms),
                    _buildProgressCard("Cigarettes Not Smoked", "$cigarettesNotSmoked", Icons.smoke_free),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProcessScreen(
                          cigaretteManager: YourCigaretteManager(),
                          htimes: [
                            {"id": 1, "time": const Duration(days: 30)},
                            {"id": 2, "time": const Duration(days: 14)},
                            {"id": 3, "time": const Duration(days: 7)},
                          ],
                          lang: 'en',
                        ),
                      ),
                    );
                  },
                  child: const Text('Achievements'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    double totalCost = (widget.cigarettesPerDay / widget.cigarettesInPack) * widget.costPerPack * goalDays;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletScreen(
                          moneySaved: moneyWasted,
                          quitDate: widget.startDate,
                          totalCost: totalCost,
                        ),
                      ),
                    );
                  },
                  child: const Text('Wallet'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'QuitCoach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProgressCard(String title, String value, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.teal),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${minutes}m ${seconds}s";
  }
}
