import 'package:flutter/material.dart';
import 'package:wisata/api_manager.dart';
import 'package:wisata/daftar_wisata.dart';
import 'update_wisata.dart';

class DetailWisataScreen extends StatelessWidget {
  final int id;
  final String nama;
  final String deskripsi;
  final String alamat;
  final int harga;
  final String gambar;

  DetailWisataScreen({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.alamat,
    required this.harga,
    required this.gambar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(gambar),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    nama,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    deskripsi,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Alamat:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    alamat,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Harga:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    harga.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateWisataPage(wisataData: {
                            'id': id,
                            'nama': nama,
                            'gambar': gambar,
                            'deskripsi': deskripsi,
                            'alamat': alamat,
                            'harga': harga,
                          }),
                        ),
                      ).then((result) {
                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Wisata berhasil diupdate!'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => DaftarWisata(apiManager: ApiManager(baseUrl: 'http:// 10.10.24.11:8000'))),
                            );
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bool deleteConfirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Konfirmasi Hapus'),
                            content: Text('Apakah Anda yakin ingin menghapus data ini?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Hapus'),
                              ),
                            ],
                          );
                        },
                      );

                      if (deleteConfirmed == true) {
                        try {
                          await ApiManager(baseUrl: 'http://10.10.24.11:8000').deleteWisata(id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Wisata berhasil dihapus!'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => DaftarWisata(apiManager: ApiManager(baseUrl: 'http:/ 10.10.24.11:8000'))),
                            );
                          });

                        } catch (e) {
                          print('Error: $e');
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
