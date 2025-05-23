import 'package:flutter/material.dart';
import 'package:sqlite_buku_flutter/helper/db_helper.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart';

class EditBukuView extends StatefulWidget {
  final ModelBuku buku;

  const EditBukuView({super.key, required this.buku});

  @override
  State<EditBukuView> createState() => _EditBukuViewState();
}

class _EditBukuViewState extends State<EditBukuView> {
  late TextEditingController _judulBukuController;
  late TextEditingController _kategoriBukuController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _judulBukuController = TextEditingController(text: widget.buku.judulbuku);
    _kategoriBukuController = TextEditingController(text: widget.buku.kategori);
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      final updatedBuku = ModelBuku(
        id: widget.buku.id,
        judulbuku: _judulBukuController.text.trim(),
        kategori: _kategoriBukuController.text.trim(),
      );

      await DatabaseHelper.instance.updateBuku(updatedBuku);

      // Kembali ke halaman sebelumnya dan beri sinyal bahwa data berhasil diperbarui
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = const Color(0xFF7F5AF0);
    final Color lightPurple = const Color(0xFFF5EDFF);

    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        title: const Text('Edit Buku'),
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
                    'Form Edit Data Buku',
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
                        'SIMPAN PERUBAHAN',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _updateData,
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
