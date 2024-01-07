import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';
import 'user_manager.dart';

class Login extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _authenticate(BuildContext context) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);
    final userManager = Provider.of<UserManager>(context, listen: false);

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final token = await apiManager.authenticate(username, password);
      userManager.setAuthToken(token);
      Navigator.pushReplacementNamed(context, '/daftar_wisata');
    } catch (e) {
      print('Authentication failed. Error: $e');
      // Handle authentication failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('bg.jpg'), // Ganti dengan path sesuai file gambar Anda
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 54, 54, 54)),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 54, 54, 54)),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _authenticate(context),
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
