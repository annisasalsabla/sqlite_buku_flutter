// editbuku_view.dart
import 'package:flutter/material.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart';
import 'package:sqlite_buku_flutter/helper/db_helper.dart';

class EditbukuView extends StatefulWidget {
  final ModelBuku buku;
  const EditbukuView({super.key, required this.buku});

  @override
  State<EditbukuView> createState() => _EditbukuViewState();
}

class _EditbukuViewState extends State<EditbukuView> {
  final _judulBukuController = TextEditingController();
  final _kategoriBukuController = TextEditingController();

  bool _validateJudul = false;
  bool _validateKategori = false;

  @override
  void initState() {
    super.initState();
    _judulBukuController.text = widget.buku.judulbuku;
    _kategoriBukuController.text = widget.buku.kategori;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Buku'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Data Buku',
                style: TextStyle(
                    fontSize: 20, color: Colors.teal, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _judulBukuController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Masukkan Judul Buku',
                    labelText: 'Judul Buku',
                    errorText: _validateJudul ? 'Judul Tidak boleh kosong' : null),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _kategoriBukuController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Masukkan Kategori Buku',
                    labelText: 'Kategori Buku',
                    errorText:
                    _validateKategori ? 'Kategori Tidak boleh kosong' : null),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.teal,
                        textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      setState(() {
                        _validateJudul = _judulBukuController.text.isEmpty;
                        _validateKategori = _kategoriBukuController.text.isEmpty;
                      });
                      if (!_validateJudul && !_validateKategori) {
                        await DatabaseHelper.instance.updateBuku(ModelBuku(
                          id: widget.buku.id,
                          judulbuku: _judulBukuController.text,
                          kategori: _kategoriBukuController.text,
                        ));
                        Navigator.pop(context, true);
                      }
                    },
                    child: Text('Update Details'),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      _judulBukuController.clear();
                      _kategoriBukuController.clear();
                    },
                    child: Text('Clear Details'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
