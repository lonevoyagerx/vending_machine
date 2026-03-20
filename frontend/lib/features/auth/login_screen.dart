import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  String? _validateInput() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      return 'Please enter a valid email';
    }
    if (_passwordController.text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _login() async {
    // MOCK LOGIN BYPASS
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Fake network delay
    if (mounted) {
      context.go('/products');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in with Mock Account')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _signUp() async {
    final error = _validateInput();
    if (error != null) {
      _showError(error);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUp(
        _emailController.text.trim(), 
        _passwordController.text
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign Up Successful! Please check your email to confirm.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 422 most likely means password too short or bad email, which validation should catch,
      // but also could be other Supabase constraints.
       _showError(e is AuthException ? e.message : 'Sign Up Failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vending Machine Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
            if (!_isLoading) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: _signUp,
                child: const Text('Create Account'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
