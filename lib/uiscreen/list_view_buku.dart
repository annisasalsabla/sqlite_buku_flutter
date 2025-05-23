import 'package:flutter/material.dart';
import 'package:sqlite_buku_flutter/helper/db_helper.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart';
import 'package:sqlite_buku_flutter/uiscreen/addbuku_view.dart';
import 'package:sqlite_buku_flutter/uiscreen/editbuku_view.dart';

class ListDataBukuView extends StatefulWidget {
  const ListDataBukuView({super.key});

  @override
  State<ListDataBukuView> createState() => _ListDataBukuViewState();
}

class _ListDataBukuViewState extends State<ListDataBukuView> {
  List<ModelBuku> _listBuku = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _insertDummyIfNeeded();
      await _fetchDataBuku();
    } catch (e) {
      debugPrint('❌ Error saat load data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _insertDummyIfNeeded() async {
    final existingData = await DatabaseHelper.instance.queryAllBuku();
    if (existingData.isEmpty) {
      debugPrint('📥 Data kosong. Menambahkan dummy...');
      await DatabaseHelper.instance.initializeDataBuku();
    } else {
      debugPrint('✅ Data sudah ada. Tidak menambahkan dummy.');
    }
  }

  Future<void> _fetchDataBuku() async {
    final data = await DatabaseHelper.instance.queryAllBuku();
    setState(() {
      _listBuku = data.map((e) => ModelBuku.fromMap(e)).toList();
    });
  }

  Future<void> _showOptionsDialog(ModelBuku buku) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.indigo),
            title: const Text('Edit'),
            onTap: () async {
              Navigator.pop(context); // Tutup bottom sheet
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditBukuView(buku: buku)),
              );
              if (result == true) {
                await _fetchDataBuku();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('✅ Data berhasil diperbarui'),
                    backgroundColor: Colors.green[600],
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Hapus'),
            onTap: () async {
              Navigator.pop(context); // Tutup bottom sheet
              final confirm = await _showDeleteConfirmationDialog(buku.judulbuku);
              if (confirm == true) {
                await DatabaseHelper.instance.deleteUser(buku.id!);
                await _fetchDataBuku();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('🗑️ Data berhasil dihapus'),
                    backgroundColor: Colors.red[600],
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(String judulBuku) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus buku "$judulBuku"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Buku'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listBuku.isEmpty
          ? const Center(child: Text('Data buku tidak tersedia.'))
          : ListView.builder(
        itemCount: _listBuku.length,
        itemBuilder: (context, index) {
          final buku = _listBuku[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(buku.id?.toString() ?? '?'),
            ),
            title: Text(buku.judulbuku),
            subtitle: Text(buku.kategori),
            onTap: () {},
            onLongPress: () => _showOptionsDialog(buku),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddbukuView()),
          );

          if (result == true) {
            await _fetchDataBuku();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('📚 Data berhasil ditambahkan'),
                backgroundColor: Colors.blue[600],
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
