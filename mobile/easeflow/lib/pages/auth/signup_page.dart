// lib/pages/auth/signup_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final guardianIdController = TextEditingController();

  String role = 'guardian'; // parent or child
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Replace with your backend endpoint
  final String backendUrl = 'https://jamie-subsatirical-abbreviatedly.ngrok-free.dev/auth/sign_up';

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final payload = {
        'displayName': displayNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'role': role,
        if (role == 'child') 'guardianId': guardianIdController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final result = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        // Success: navigate based on role
        if (role == 'guardian') {
          Navigator.pushReplacementNamed(context, '/');
        } else {
          Navigator.pushReplacementNamed(context, '/child-home');
        }
      } else {
        // Show backend error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    guardianIdController.dispose();
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // DISPLAY NAME
                    TextFormField(
                      controller: displayNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.person, color: Colors.teal),
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
                      validator: (value) =>
                          value!.isEmpty ? 'Enter display name' : null,
                    ),
                  const SizedBox(height: 20),

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
                    validator: (value) =>
                        value!.isEmpty ? 'Enter email' : null,
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
                    validator: (value) =>
                        value!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 20),

                  // CONFIRM PASSWORD
                  TextFormField(
                    controller: confirmController,
                    obscureText: _obscureConfirm,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
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
                    validator: (value) =>
                        value != passwordController.text
                            ? 'Passwords do not match'
                            : null,
                  ),
                  const SizedBox(height: 20),

                  // ROLE SELECTOR (styled dropdown)
                  DropdownButtonFormField<String>(
                    value: role,
                    dropdownColor: Colors.grey.shade900,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Role',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.person, color: Colors.teal),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                    onChanged: (value) {
                      if (value != null) setState(() => role = value);
                    },
                    items: const [
                      DropdownMenuItem(value: 'guardian', child: Text('Guardian')),
                      DropdownMenuItem(value: 'child', child: Text('Child')),
                    ],
                    validator: (value) => value == null || value.isEmpty ? 'Select role' : null,
                  ),
                  const SizedBox(height: 20),

                  // GUARDIAN ID (only for child)
                  if (role == 'child')
                    TextFormField(
                      controller: guardianIdController,
                      decoration: const InputDecoration(
                        labelText: 'Guardian ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => role == 'child' && value!.isEmpty
                          ? 'Enter guardian ID'
                          : null,
                    ),
                  if (role == 'child') const SizedBox(height: 20),

                  // SIGNUP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: _loading
                        ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                        : ElevatedButton(
                            onPressed: _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),)
    );
  }
}