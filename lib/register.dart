import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

void _register(BuildContext context) async {
  final apiManager = Provider.of<ApiManager>(context, listen: false);

  final name = _nameController.text;
  final username = _usernameController.text;
  final password = _passwordController.text;

  try {
    await apiManager.register(name, username, password);

    // Show a toast on successful registration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi berhasil!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacementNamed(context, '/');
    // Handle successful registration
  } catch (e) {
    // Handle registration failure
    String errorMessage = 'Terjadi kesalahan saat registrasi';
    
    if (e.toString().contains('email sudah terdaftar')) {
      errorMessage = 'Akun sudah terdaftar';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 2),
      ),
    );

    print('Registration failed. Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
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
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Color.fromARGB(255, 54, 54, 54)),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 54, 54, 54)),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 54, 54, 54)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _register(context),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
