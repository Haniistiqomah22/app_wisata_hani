import 'dart:convert';
import 'dart:js_interop_unsafe';
import 'dart:io';
import 'package:flutter/material.dart';
import 'tambah_wisata_form.dart';
import 'wisata_model.dart';
import 'api_manager.dart';
import 'update_wisata.dart';

class DaftarWisata extends StatefulWidget {
  final ApiManager apiManager;

  DaftarWisata({required this.apiManager});

  @override
  _DaftarWisataState createState() => _DaftarWisataState();
}

class _DaftarWisataState extends State<DaftarWisata> {
  late Future<List<DetailWisataData>> _wisata;

  @override
  void initState() {
    super.initState();
    _wisata = widget.apiManager.fetchWisata();
  }

  void filterSearchResults(String query, List<DetailWisataData> allWisata) {
    if (query.isNotEmpty) {
      List<DetailWisataData> searchListData = allWisata
          .where((wisata) =>
              wisata.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _wisata = Future.value(searchListData);
      });
      return;
    } else {
      setState(() {
        _wisata = widget.apiManager.fetchWisata();
      });
    }
  }
  Future<void> _refreshData() async {
  setState(() {
    _wisata = widget.apiManager.fetchWisata();
  });
}

  void _showAddWisataForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TambahWisataPage();
      },
    );
  }

  void _tambahDataWisata(
      String nama, String gambar, String deskripsi, String alamat, double harga) {
    widget.apiManager.tambahDataWisata(
        nama, gambar, deskripsi, alamat, harga);

    setState(() {
      _wisata = widget.apiManager.fetchWisata();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DetailWisataData>>(
        future: _wisata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan: ${snapshot.error}'));
          } else {
            List<DetailWisataData> allWisata = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset('logo.png', height: 100, width: 100),
                        SizedBox(width: 8),
                        Text(
                          'Wisata Populer',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hallo!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hari yang cerah, mau pergi kemana hari ini?',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value, allWisata);
                      },
                      decoration: InputDecoration(
                        labelText: 'Cari destinasi wisata . . .',
                        hintText: 'Masukkan nama wisata',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: allWisata.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailWisataScreen(
                                id: allWisata[index].id,
                                nama: allWisata[index].nama,
                                deskripsi: allWisata[index].deskripsi,
                                alamat: allWisata[index].alamat,
                                harga: allWisata[index].harga,
                                gambar: "${allWisata[index].gambar}",
                              ),
                            ),
                          );
                        },
                        child: buildWisataCard(
                          allWisata[index].id,
                          allWisata[index].nama,
                          allWisata[index].gambar,
                          allWisata[index].deskripsi,
                          allWisata[index].alamat,
                          allWisata[index].harga,
                          "http://10.10.24.10:8000/storage/images/${allWisata[index].gambar}",
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        _showAddWisataForm(context);
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildWisataCard(int id, String nama, String gambar, String deskripsi, String alamat, int harga, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0,
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: NetworkImage('${gambar}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nama,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateWisataPage(wisataData: {
                                    'id': id, // Replace with the actual ID of the data
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

                                  _refreshData();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
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
                                        onPressed: () async {
                                try {
                                  // Replace 1 with the actual ID of the data to be deleted
                                  await ApiManager(baseUrl: 'http://192.168.1.7:8000/api').deleteWisata(id);
                                  print('Delete Wisata: $nama');

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Wisata berhasil dihapus!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                    Navigator.of(context).pop(false);
                                  Future.delayed(Duration(seconds: 2), () {
                                    _refreshData();
                                  });

                                } catch (e) {
                                  print('Error: $e');
                                }
                              
                                        },
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
