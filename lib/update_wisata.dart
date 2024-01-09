import 'package:flutter/material.dart';
import 'api_manager.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateWisataPage extends StatefulWidget {
  final Map<String, dynamic> wisataData;
  final ApiManager apiManager = ApiManager(baseUrl: 'http://10.10.24.11:8000/api');

  UpdateWisataPage({required this.wisataData});

  @override
  _UpdateWisataPageState createState() => _UpdateWisataPageState();
}

class _UpdateWisataPageState extends State<UpdateWisataPage> {
  late TextEditingController _idController;
  late TextEditingController _namaController;
  late TextEditingController _gambarController;
  late TextEditingController _deskripsiController;
  late TextEditingController _alamatController;
  late TextEditingController _hargaController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _idController = TextEditingController(text: widget.wisataData['id'].toString());
    _namaController = TextEditingController(text: widget.wisataData['nama']);
    _gambarController = TextEditingController(text: widget.wisataData['gambar']);
    _deskripsiController = TextEditingController(text: widget.wisataData['deskripsi']);

    _alamatController = TextEditingController(text: widget.wisataData['alamat']);
    _hargaController = TextEditingController(text: widget.wisataData['harga'].toString());
  }

  @override
  void dispose() {
    _idController.dispose();
    _namaController.dispose();
    _gambarController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _updateWisata(BuildContext context) async {
    String id = _idController.text;
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
      return;
    }

    try {
      await widget.apiManager.updateWisata(
        id,
        nama,
        gambar,
        deskripsi,
        alamat,
        harga,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wisata berhasil diupdate!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Coba lagi nanti. $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
        title: Text('Update Wisata', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 66, 163, 243),
        iconTheme: IconThemeData(color: Colors.white),
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
                    Text('Input Foto Wisata'),
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
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            Image.network(
              "${widget.wisataData['gambar']}",
              height: 100,
              width: 100,
            ),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: _hargaController,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                _updateWisata(context);
              },
              child: Text('Update Wisata'),
            ),
          ],
        ),
      ),
    );
  }
}
