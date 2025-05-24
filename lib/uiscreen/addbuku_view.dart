import 'package:flutter/material.dart';
import 'package:sqlite_buku_flutter/helper/db_helper.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart';

class AddbukuView extends StatefulWidget {
  const AddbukuView({super.key});

  @override
  State<AddbukuView> createState() => _AddbukuViewState();
}

class _AddbukuViewState extends State<AddbukuView> {
  var _judulBukuController = TextEditingController();
  var _kategoriBukuController = TextEditingController();

  bool _validateJudul = false;
  bool _validateKategori = false;

  void _saveDetails() async {
    setState(() {
      _validateJudul = _judulBukuController.text.isEmpty;
      _validateKategori = _kategoriBukuController.text.isEmpty;
    });

    if (!_validateJudul && !_validateKategori) {
      ModelBuku buku = ModelBuku(
        judulbuku: _judulBukuController.text,
        kategori: _kategoriBukuController.text,
      );

      await DatabaseHelper.instance.insertBuku(buku);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data buku berhasil disimpan!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Balik ke halaman list dan auto-refresh
    }
  }

  void _clearDetails() {
    setState(() {
      _judulBukuController.clear();
      _kategoriBukuController.clear();
      _validateJudul = false;
      _validateKategori = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data Buku'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Buku',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _judulBukuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan Judul Buku',
                  labelText: 'Judul Buku',
                  errorText: _validateJudul ? 'Judul tidak boleh kosong' : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _kategoriBukuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan Kategori Buku',
                  labelText: 'Kategori Buku',
                  errorText: _validateKategori ? 'Kategori tidak boleh kosong' : null,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveDetails,
                    child: Text('Save Details'),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _clearDetails,
                    child: Text('Clear Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
