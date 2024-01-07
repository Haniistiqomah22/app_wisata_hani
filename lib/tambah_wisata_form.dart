import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';

class TambahWisataForm extends StatefulWidget {
  
  final void Function(String, String, String, String, double) onTambahWisata;

  TambahWisataForm({required this.onTambahWisata});

  @override
  _TambahWisataFormState createState() => _TambahWisataFormState();
}

class _TambahWisataFormState extends State<TambahWisataForm> {
  TextEditingController gambarController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  File? _selectedImage;

  void _addTambahWisata(BuildContext context) async {
  final apiManager = Provider.of<ApiManager>(context, listen: false);

  String gambar = gambarController.text;
  String nama = namaController.text;
  String deskripsi = deskripsiController.text;
  String alamat = alamatController.text;
  String harga = hargaController.text;

  try {
    // Call the API to add the new "Wisata"
    apiManager.addTambahWisata(_selectedImage!, nama, deskripsi, alamat, harga);

    // Handle success, e.g., show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Wisata added successfully'),
    ));

    // Optionally, you can call the callback to notify the parent widget
    widget.onTambahWisata(nama, gambar, deskripsi, alamat, double.parse(harga));

    // Close the form or navigate back
    Navigator.pop(context);
  } catch (e) {
    // Handle errors, e.g., show an error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to add Wisata: $e'),
      backgroundColor: Colors.red,
    ));
  }
}

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        gambarController.text = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Data Wisata'),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
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
                      Text('Input Objek Wisata'),
                    ],
                  ),
                ),
              ),
              // Tampilkan gambar yang dipilih
              if (_selectedImage != null)
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Wisata'),
              ),
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            // Call the method to add Wisata
            _addTambahWisata(context);
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
