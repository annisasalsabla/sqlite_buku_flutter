// listdatabuku_view.dart
import 'package:flutter/material.dart';
import 'package:sqlite_buku_flutter/helper/db_helper.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart';
import 'package:sqlite_buku_flutter/uiscreen/addbuku_view.dart';
import 'package:sqlite_buku_flutter/uiscreen/editbuku_view.dart';

class ListdatabukuView extends StatefulWidget {
  const ListdatabukuView({super.key});

  @override
  State<ListdatabukuView> createState() => _ListdatabukuViewState();
}

class _ListdatabukuViewState extends State<ListdatabukuView> {
  List<ModelBuku> _buku = [];

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.dummyBuku();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async {
    final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
    });
  }

  void _deleteDialog(int id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Center(
            child: Text(
              "Are You Sure to Delete",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
              onPressed: () async {
                await DatabaseHelper.instance.deleteUser(_buku[index].id!);
                Navigator.pop(context);
                _fetchDataBuku();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User Detail Deleted Success"),
                    backgroundColor: Colors.black87,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Data Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchDataBuku,
          )
        ],
      ),
      body: _buku.isEmpty
          ? Center(child: Text("Belum ada data buku."))
          : ListView.builder(
        itemCount: _buku.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _deleteDialog(_buku[index].id!, index);
            },
            child: ListTile(
              title: Text(_buku[index].judulbuku),
              subtitle: Text(_buku[index].kategori),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditbukuView(buku: _buku[index]),
                  ),
                );
                if (result == true) {
                  _fetchDataBuku();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Berhasil update"),
                      backgroundColor: Colors.teal,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddbukuView()));
          _fetchDataBuku(); // Refresh setelah tambah
        },
        child: Icon(Icons.add),
      ),
    );
  }
}