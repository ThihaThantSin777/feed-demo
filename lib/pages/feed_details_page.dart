import 'package:flutter/material.dart';

class FeedDetailsPage extends StatelessWidget {
  final Map<String, dynamic> feed;

  const FeedDetailsPage({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feed['text'] ?? 'No Content', style: const TextStyle(fontSize: 18)),
            if (feed['image'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(feed['image']),
              ),
            Text('Timestamp: ${feed['timestamp'] ?? 'Unknown'}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
