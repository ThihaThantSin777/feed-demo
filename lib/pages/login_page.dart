import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample_feed/pages/feed_list_page.dart';
import 'package:sample_feed/pages/register_page.dart';
import 'package:sample_feed/widgets/error_dialog_widget.dart';
import 'package:sample_feed/widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeedListPage()));
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
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                ElevatedButton(onPressed: _login, child: const Text('Login')),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
          if (_isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
