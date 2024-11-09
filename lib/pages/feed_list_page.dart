import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sample_feed/pages/create_feed_page.dart';
import 'package:sample_feed/pages/feed_details_page.dart';
import 'package:sample_feed/widgets/error_dialog_widget.dart';
import 'package:sample_feed/widgets/loading_widget.dart';

class FeedListPage extends StatefulWidget {
  const FeedListPage({super.key});

  @override
  State<FeedListPage> createState() => _FeedListPageState();
}

class _FeedListPageState extends State<FeedListPage> {
  final DatabaseReference _feedsRef = FirebaseDatabase.instance.ref().child('feeds');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feeds')),
      body: StreamBuilder<DatabaseEvent>(
        stream: _feedsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorDialogWidget(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
            final feeds = data.values.map((feed) => Map<String, dynamic>.from(feed)).toList();

            return ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                final feed = feeds[index];
                return ListTile(
                  title: Text(feed['text'] ?? 'No Content'),
                  subtitle: feed['image'] != null ? Image.network(feed['image']) : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeedDetailsPage(feed: feed),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('No feeds available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateFeedPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
