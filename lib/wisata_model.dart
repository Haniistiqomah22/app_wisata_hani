import 'dart:convert';
import 'package:http/http.dart' as http;

Future<DetailWisataData> fetchDetailWisataData(String nama) async {
  final response = await http.get(
    Uri.parse('http://10.10.24.10:8000/api/$nama'), // Ganti URL dengan endpoint sesuai kebutuhan
  );

  if (response.statusCode == 200) {
    // Jika permintaan berhasil (status code 200), parsing data JSON
    Map<String, dynamic> jsonData = json.decode(response.body);

    return DetailWisataData(
      nama: jsonData['nama'],
      deskripsi: jsonData['deskripsi'],
      alamat: jsonData['alamat'],
      harga: jsonData['harga'],
      gambar: jsonData['gambar'],
    );
  } else {
    // Jika permintaan gagal, lempar exception
    throw Exception('Failed to load data');
  }
}

class DetailWisataData {
  final String nama;
  final String deskripsi;
  final String alamat;
  final int harga; // Ubah tipe data menjadi int
  final String gambar;

  DetailWisataData({
    required this.nama,
    required this.deskripsi,
    required this.alamat,
    required this.harga,
    required this.gambar,
  });

  // Menambahkan factory constructor untuk mengonversi dari JSON
  factory DetailWisataData.fromJson(Map<String, dynamic> json) {
    return DetailWisataData(
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
      harga: int.parse(json['harga'].toString()), // Konversi dari String ke int
      gambar: json['gambar'],
    );
  }
}

