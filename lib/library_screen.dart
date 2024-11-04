import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show a notification upon entering the Library screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Welcome to the Library! Explore ways to stay motivated and stress-free.'),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          backgroundColor: const Color(0xFF333333),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('When You\'re Stressed...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Deep breathing',
                      duration: '4 MIN',
                      icon: Icons.air,
                      description: 'Take deep breaths to relax and calm your mind.',
                      graphicIcon: Icons.air,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Muscle relaxation',
                      duration: '7 MIN',
                      icon: Icons.self_improvement,
                      description: 'Relax each muscle group to relieve tension.',
                      graphicIcon: Icons.self_improvement,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Meditation',
                      duration: '10 MIN',
                      icon: Icons.spa,
                      description: 'Guided meditation to focus on relaxation.',
                      graphicIcon: Icons.spa,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Yoga',
                      duration: '15 MIN',
                      icon: Icons.accessibility_new,
                      description: 'Reduce tension and improve mental clarity.',
                      graphicIcon: Icons.accessibility_new,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Stretching',
                      duration: '5 MIN',
                      icon: Icons.accessibility_new,
                      description: 'Stretch to release built-up tension.',
                      graphicIcon: Icons.accessibility_new,
                    ),
                  ],
                ),
                _buildSectionTitle('When You Need Motivation...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Rise above craving',
                      duration: '2 MIN',
                      icon: Icons.sunny,
                      description: 'Focus on your goals to overcome cravings.',
                      graphicIcon: Icons.wb_sunny,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Challenge yourself',
                      duration: '2 MIN',
                      icon: Icons.terrain,
                      description: 'Push yourself beyond limits.',
                      graphicIcon: Icons.terrain,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Stay focused',
                      duration: '3 MIN',
                      icon: Icons.center_focus_strong,
                      description: 'Maintain focus on your goals.',
                      graphicIcon: Icons.center_focus_strong,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Inspire yourself',
                      duration: '5 MIN',
                      icon: Icons.lightbulb,
                      description: 'Find inspiration in success stories.',
                      graphicIcon: Icons.lightbulb,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Reward yourself',
                      duration: '5 MIN',
                      icon: Icons.card_giftcard,
                      description: 'Celebrate victories with healthy rewards.',
                      graphicIcon: Icons.card_giftcard,
                    ),
                  ],
                ),
                _buildSectionTitle('When the Craving is Strong...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Visualize success',
                      duration: '5 MIN',
                      icon: Icons.visibility,
                      description: 'Imagine yourself succeeding.',
                      graphicIcon: Icons.visibility,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Distract yourself',
                      duration: '3 MIN',
                      icon: Icons.gamepad,
                      description: 'Engage in hobbies to shift focus.',
                      graphicIcon: Icons.videogame_asset,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Listen to music',
                      duration: '4 MIN',
                      icon: Icons.headset,
                      description: 'Play your favorite songs.',
                      graphicIcon: Icons.headset,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Go for a walk',
                      duration: '6 MIN',
                      icon: Icons.directions_walk,
                      description: 'Walking clears your mind.',
                      graphicIcon: Icons.directions_walk,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Chew gum',
                      duration: '2 MIN',
                      icon: Icons.fastfood,
                      description: 'Chewing gum reduces smoking urges.',
                      graphicIcon: Icons.fastfood,
                    ),
                  ],
                ),
                _buildSectionTitle('Healthy Habits...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Drink water',
                      duration: '2 MIN',
                      icon: Icons.local_drink,
                      description: 'Stay hydrated to manage cravings.',
                      graphicIcon: Icons.local_drink,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Healthy snacks',
                      duration: '5 MIN',
                      icon: Icons.restaurant,
                      description: 'Choose fruits or nuts as healthy snacks.',
                      graphicIcon: Icons.restaurant,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Stretch',
                      duration: '3 MIN',
                      icon: Icons.accessibility_new,
                      description: 'Release tension and improve flexibility.',
                      graphicIcon: Icons.accessibility_new,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Exercise',
                      duration: '10 MIN',
                      icon: Icons.fitness_center,
                      description: 'Boost mood and reduce stress.',
                      graphicIcon: Icons.fitness_center,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Sleep well',
                      duration: '8 HOURS',
                      icon: Icons.bedtime,
                      description: 'Good sleep helps manage stress.',
                      graphicIcon: Icons.bedtime,
                    ),
                  ],
                ),
                _buildSectionTitle('Positive Mindset...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Practice gratitude',
                      duration: '5 MIN',
                      icon: Icons.favorite,
                      description: 'Focus on positive things in your life.',
                      graphicIcon: Icons.favorite,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Affirmations',
                      duration: '5 MIN',
                      icon: Icons.assignment_turned_in,
                      description: 'Use positive affirmations for motivation.',
                      graphicIcon: Icons.assignment_turned_in,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Mindful journaling',
                      duration: '10 MIN',
                      icon: Icons.book,
                      description: 'Write down thoughts and reflect.',
                      graphicIcon: Icons.book,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Self-Reflection',
                      duration: '6 MIN',
                      icon: Icons.self_improvement,
                      description: 'Reflect on personal growth and progress.',
                      graphicIcon: Icons.self_improvement,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Celebrate Small Wins',
                      duration: '2 MIN',
                      icon: Icons.celebration,
                      description: 'Acknowledge and celebrate your progress.',
                      graphicIcon: Icons.celebration,
                    ),
                  ],
                ),
                _buildSectionTitle('Productivity Boosters...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Set goals',
                      duration: '10 MIN',
                      icon: Icons.flag,
                      description: 'Plan achievable daily goals.',
                      graphicIcon: Icons.flag,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Take breaks',
                      duration: '5 MIN',
                      icon: Icons.free_breakfast,
                      description: 'Take short breaks to reset your focus.',
                      graphicIcon: Icons.free_breakfast,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Stay organized',
                      duration: '10 MIN',
                      icon: Icons.assignment,
                      description: 'Keep a to-do list for clarity.',
                      graphicIcon: Icons.assignment,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Prioritize',
                      duration: '6 MIN',
                      icon: Icons.priority_high,
                      description: 'Focus on tasks that matter most.',
                      graphicIcon: Icons.priority_high,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Declutter Workspace',
                      duration: '10 MIN',
                      icon: Icons.cleaning_services,
                      description: 'Clear your workspace to boost productivity.',
                      graphicIcon: Icons.cleaning_services,
                    ),
                  ],
                ),
                _buildSectionTitle('Mental Clarity...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Mindfulness',
                      duration: '10 MIN',
                      icon: Icons.psychology,
                      description: 'Practice being present in the moment.',
                      graphicIcon: Icons.psychology,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Breathing exercises',
                      duration: '5 MIN',
                      icon: Icons.bubble_chart,
                      description: 'Focus on deep breathing for clarity.',
                      graphicIcon: Icons.bubble_chart,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Stay Present',
                      duration: '4 MIN',
                      icon: Icons.watch_later,
                      description: 'Focus on the present moment for clarity.',
                      graphicIcon: Icons.watch_later,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Clear Thoughts',
                      duration: '7 MIN',
                      icon: Icons.clear_all,
                      description: 'Practice mental decluttering daily.',
                      graphicIcon: Icons.clear_all,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Reflection',
                      duration: '6 MIN',
                      icon: Icons.mood,
                      description: 'Reflect on your thoughts and feelings.',
                      graphicIcon: Icons.mood,
                    ),
                  ],
                ),
                _buildSectionTitle('Time Management...'),
                _buildHorizontalScrollSection(
                  context,
                  [
                    _buildLibraryItem(
                      context,
                      title: 'Prioritize tasks',
                      duration: '15 MIN',
                      icon: Icons.event_note,
                      description: 'Focus on the most important tasks.',
                      graphicIcon: Icons.event_note,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Limit distractions',
                      duration: '5 MIN',
                      icon: Icons.notifications_off,
                      description: 'Turn off non-essential notifications.',
                      graphicIcon: Icons.notifications_off,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Batch Tasks',
                      duration: '10 MIN',
                      icon: Icons.merge_type,
                      description: 'Group similar tasks to improve efficiency.',
                      graphicIcon: Icons.merge_type,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Set Deadlines',
                      duration: '6 MIN',
                      icon: Icons.timelapse,
                      description: 'Give yourself time limits to focus.',
                      graphicIcon: Icons.timelapse,
                    ),
                    _buildLibraryItem(
                      context,
                      title: 'Schedule Breaks',
                      duration: '5 MIN',
                      icon: Icons.free_breakfast,
                      description: 'Plan breaks to stay refreshed.',
                      graphicIcon: Icons.free_breakfast,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for section titles and horizontal scrollable sections
  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildHorizontalScrollSection(
      BuildContext context, List<Widget> items) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }

  // Builds individual library items with dialog functionality
  Widget _buildLibraryItem(BuildContext context,
      {required String title,
      required String duration,
      required IconData icon,
      required String description,
      required IconData graphicIcon}) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF2C2C2C),
                  title: Text(
                    title,
                    style: const TextStyle(color: Colors.teal),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        graphicIcon,
                        color: Colors.teal,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.teal,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
