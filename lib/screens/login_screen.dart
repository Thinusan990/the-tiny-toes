import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_tiny_toes/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() { _isLoading = true; });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_usernameController.text, _passwordController.text);
      Navigator.pushReplacementNamed(context, '/users');
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid username or password'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('OK'))
          ],
        ),
      );
    }
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
