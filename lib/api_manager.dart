import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wisata/wisata_model.dart';

class ApiManager {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiManager({required this.baseUrl});

  Future<String?> addWisata(String nama, String gambar, String deskripsi, String alamat, String harga ) async {
  try {
    final token = await getToken();

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/store-gambar'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['nama'] = nama;
    request.fields['gambar'] = gambar;
    request.fields['deskripsi'] = deskripsi;
    request.fields['alamat'] = alamat;
    request.fields['harga'] = harga;
    

    var response = await request.send();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      final addedWisataId = jsonResponse['id'].toString();
      return addedWisataId;
    } else {
      throw Exception('Failed Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in addWisata: $e');
    throw e;
  }
}


  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/wisata'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        throw Exception(
            'Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchData: $e');
      throw e;
    }
  }

  Future<void> updateWisata(
    String id,
    String nama,
    String gambar,
    String deskripsi,
    String alamat,
    String harga,
  ) async {

      final token = await getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/wisata/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': nama,
          'gambar': gambar,
          'deskripsi': deskripsi,
          'alamat': alamat,
          'harga': harga,
        }),
      );


  }

  Future<int> deleteWisata(int id) async {
  try {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/wisata/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Respon Delete: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
          'Gagal menghapus wisata. Kode Status: ${response.statusCode}');
    } else {
      return response.statusCode;
    }
  } catch (e) {
    print('Error dalam deletewisata: $e');
    throw e;
  }
}

  Future<String> getToken() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token is null');
    }
    return token;
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        final token = "Successfully";
        return token;
      } else {
        throw Exception(
            'Failed to register, email already exists. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in register: $e');
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'password': password},
      );

      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];

      await storage.write(key: 'auth_token', value: token);
    } catch (e) {
      print('Error in login: $e');
      throw e;
    }
  }

  Future<String?> authenticate(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'];

        await storage.write(key: 'auth_token', value: token);

        return token;
      } else {
        throw Exception(
            'Failed to authenticate. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in authenticate: $e');
      throw e;
    }
  }

Future<String?> addTambahWisata(File gambar, String nama, String deskripsi, String alamat,  harga) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/store-gambar'));
    request.fields['nama'] = nama;
    request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    request.fields['deskripsi'] = deskripsi;
    request.fields['alamat'] = alamat;
    request.fields['harga'] = harga.toString(); // Ubah tipe data ke String

    var response = await request.send();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      final addedWisataId = jsonResponse['id'].toString();
      return addedWisataId;
    } else {
      throw Exception('Failed Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in addTambahWisata: $e');
    throw e;
  }
}

  Future<List<DetailWisataData>> fetchWisata() async {
  final response = await http.get(Uri.parse('$baseUrl/wisata'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((e) => DetailWisataData.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load wisata');
  }
}

  void tambahDataWisata(String nama, String gambar, String deskripsi, String alamat, harga) {}

  tambahWisata(String nama, String gambar, String deskripsi, String alamat, String harga) {}

}