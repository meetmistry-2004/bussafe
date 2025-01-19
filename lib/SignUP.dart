import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bussafe/HomePage.dart';
import 'package:bussafe/LoginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              obscureText: true, // Secure password field
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Validate inputs
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Email and password cannot be empty.')),
                  );
                  return;
                }
                try {
                  await _authService.registerWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                    context,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } catch (e) {
                  print('An unexpected error occurred: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An unexpected error occurred.')),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up successful')),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Sign Up failed.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
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

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}
