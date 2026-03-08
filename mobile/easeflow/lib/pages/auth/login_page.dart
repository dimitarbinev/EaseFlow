import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true; // track visibility

  // ✅ IMPORTANT — use your REAL endpoint
  final String backendUrl =
      'https://jamie-subsatirical-abbreviatedly.ngrok-free.dev/auth/me';

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _loading = true);

    try {
      // 🔐 1. Firebase login
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      // 🎫 2. Get ID token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) throw Exception("Failed to get ID token");

      // 🌐 3. Call backend
      final response = await http.get(
        Uri.parse(backendUrl),
        headers: {
          "Authorization": "Bearer $idToken",
          "Content-Type": "application/json",
        },
      );

      if (!mounted) return;

      // 🚨 PROTECTION: avoid HTML crash
      if (!response.headers['content-type']!.contains('application/json')) {
        throw Exception(
          "Backend returned HTML instead of JSON.\nStatus: ${response.statusCode}\nBody: ${response.body.substring(0, 80)}",
        );
      }

      final profile = jsonDecode(response.body);

      // ✅ Success
      if (response.statusCode == 200) {
        if (profile['role'] == 'guardian') {
          Navigator.pushReplacementNamed(context, '/');
        } else {
          Navigator.pushReplacementNamed(context, '/child-home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profile['message'] ?? 'Login failed')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Firebase login failed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade900,
              Colors.teal.shade700,
              Colors.grey.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 24,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // HEADER
                        const SizedBox(height: 30),
                        const Icon(Icons.check_circle, size: 64, color: Colors.teal),
                        const SizedBox(height: 16),
                        const Text(
                          'EaseFlow',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Text(
                          'Task Management Made Easy',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 50),

                        // EMAIL
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white70),
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(Icons.email, color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.teal.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter email'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // PASSWORD
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white70),
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.teal.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                          validator: (value) => value == null || value.length < 6
                              ? 'Min 6 characters'
                              : null,
                        ),
                        const SizedBox(height: 40),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: _loading
                              ? const Center(
                                  child: CircularProgressIndicator(color: Colors.teal),
                                )
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),

                        // SIGNUP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/signup'),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
