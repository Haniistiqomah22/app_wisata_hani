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
      final response = await apiManager.authenticate(username, password);
      final token = response['token'];
      final role = response['role'];
      userManager.setAuthToken(token);

      if(role == 'User') {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil!'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/user_screen');

      } else  {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil!'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/daftar_wisata');
      }

      // Show a toast on successful login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil!'),
          duration: Duration(seconds: 2),
        ),
      );

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
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 54, 54, 54)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 54, 54, 54)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
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
