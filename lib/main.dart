import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata/splash_screen.dart';
import 'api_manager.dart';
import 'user_manager.dart';
import 'login.dart';
import 'register.dart';
import 'daftar_wisata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiManager apiManager = ApiManager(baseUrl: 'http://10.10.24.10:8000/api');

  //provider digunakan untuk mengirimkan data dari main.dart ke sub page, sehingga semua yang berada pada context provider bisa memanggil datanya.
  //Pada case ini data baseUrl disebar ke page lain
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserManager()),
        Provider.value(value: apiManager),
      ],
      child: MaterialApp(
        title: 'Wisata Purbalingga',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => Login(),
          '/register': (context) => RegisterPage(),
          '/daftar_wisata': (context) => DaftarWisata(apiManager: apiManager),
        },
      ),
    );
  }
}