import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {'rank': 1, 'name': 'User A', 'progress': '90%'},
    {'rank': 2, 'name': 'User B', 'progress': '85%'},
    {'rank': 3, 'name': 'User C', 'progress': '80%'},
    {'rank': 4, 'name': 'User D', 'progress': '75%'},
    {'rank': 5, 'name': 'User E', 'progress': '70%'},
  ];

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.yellowAccent;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown; // Bronze for third place
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color(0xFF333333),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Top Achievers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: leaderboardData.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade800,
                ),
                itemBuilder: (context, index) {
                  final item = leaderboardData[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRankColor(item['rank']),
                      child: Text(
                        item['rank'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      'Progress: ${item['progress']}',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                      ),
                    ),
                    trailing: index < 3
                        ? Icon(
                            Icons.emoji_events,
                            color: _getRankColor(item['rank']),
                            size: 30,
                          )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
    );
  }
}
