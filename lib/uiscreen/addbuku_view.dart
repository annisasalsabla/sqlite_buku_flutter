import 'package:flutter/material.dart';
import 'package:sqlite_buku_flutter/helper/db_helper.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart';

class AddbukuView extends StatefulWidget {
  const AddbukuView({super.key});

  @override
  State<AddbukuView> createState() => _AddbukuViewState();
}

class _AddbukuViewState extends State<AddbukuView> {
  final _judulBukuController = TextEditingController();
  final _kategoriBukuController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      final newBuku = ModelBuku(
        judulbuku: _judulBukuController.text.trim(),
        kategori: _kategoriBukuController.text.trim(),
      );

      await DatabaseHelper.instance.insertBuku(newBuku);

      // Kirim sinyal sukses ke halaman sebelumnya
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF7F5AF0); // Ungu utama
    final Color lightPurple = const Color(0xFFF5EDFF);   // Latar ungu muda

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        backgroundColor: lightPurple,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Tambah Data Buku',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _judulBukuController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Judul Buku',
                      labelStyle: TextStyle(color: primaryPurple),
                      prefixIcon: Icon(Icons.book, color: primaryPurple),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryPurple.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul buku wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _kategoriBukuController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      labelStyle: TextStyle(color: primaryPurple),
                      prefixIcon: Icon(Icons.category, color: primaryPurple),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryPurple.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kategori wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'SIMPAN',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _simpanData,
                    ),
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
