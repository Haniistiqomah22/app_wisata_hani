import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TambahWisataPage extends StatefulWidget {
  @override
  _TambahWisataPageState createState() => _TambahWisataPageState();
}

class _TambahWisataPageState extends State<TambahWisataPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  File? _selectedImage;

  void _tambahWisata(BuildContext context) async {
    final apimanager = Provider.of<ApiManager>(context, listen: false);

    String nama = _namaController.text;
    String gambar = _gambarController.text;
    String deskripsi = _deskripsiController.text;
    String alamat = _alamatController.text;
    String harga = _hargaController.text;

    if (nama.isEmpty || gambar.isEmpty || deskripsi.isEmpty || alamat.isEmpty || harga.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Semua field harus diisi!'),
        duration: Duration(seconds: 2),
      ),
    );
    return; // Hentikan eksekusi metode jika ada inputan yang kosong
  }

    try {
      await apimanager.addWisata(nama, gambar, deskripsi, alamat, harga);

      Navigator.pushReplacementNamed(context, '/daftar_wisata');
      // Tampilkan notifikasi bahwa Kost berhasil ditambahkan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wisata berhasil ditambahkan!'),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigasi kembali ke halaman sebelumnya atau sesuai kebutuhan aplikasi
      // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/daftar_wisata');
    } catch (e) {
      print('$e');
      // Tampilkan notifikasi bahwa terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Metode untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _gambarController.text = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Wisata', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 66, 163, 243),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _pickImage,
              child: Container(
                margin: EdgeInsets.only(top: 16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 8.0),
                    Text('gambar wisata'),
                  ],
                ),
              ),
            ),
            // Tampilkan gambar yang dipilih
            if (_selectedImage != null)
              Container(
                margin: EdgeInsets.only(top: 16.0),
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 10.0),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'nama'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'deksripsi '),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'alamat '),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _hargaController,
              decoration: InputDecoration(labelText: 'Harga '),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                _tambahWisata(context);
              },
              child: Text('Tambah Wisata'),
            ),
          ],
        ),
      ),
    );
  }
}