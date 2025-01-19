import 'package:bussafe/HomePage.dart';
import 'package:bussafe/driversignup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Driverloginpage extends StatefulWidget {
  @override
  State<Driverloginpage> createState() => _DriverloginpageState();
}

class _DriverloginpageState extends State<Driverloginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  _showErrorDialog(
                      context, 'Email and password cannot be empty.');
                  return;
                }
                await _authService.loginWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                  context,
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Driversignup()),
                );
              },
              child: Text('Don’t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
