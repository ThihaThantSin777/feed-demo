import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sample_feed/widgets/error_dialog_widget.dart';
import 'package:sample_feed/widgets/loading_widget.dart';

class CreateFeedPage extends StatefulWidget {
  const CreateFeedPage({super.key});

  @override
  State<CreateFeedPage> createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  final _textController = TextEditingController();
  bool _isLoading = false;

  void _uploadFeed() async {
    setState(() => _isLoading = true);
    try {
      final feedData = {
        'text': _textController.text,
        'timestamp': DateTime.now().toString(),
      };
      await FirebaseDatabase.instance.ref().child('feeds').push().set(feedData);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(context: context, builder: (_) => ErrorDialogWidget(message: e.toString()));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Feed')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(controller: _textController, decoration: const InputDecoration(labelText: 'Text')),
                  ElevatedButton(onPressed: _uploadFeed, child: const Text('Post Feed')),
                ],
              ),
            ),
          ),
          if (_isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
