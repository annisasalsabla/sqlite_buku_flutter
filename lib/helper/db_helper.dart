import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_buku_flutter/model/model_buku.dart'; // Pastikan path ini sesuai dengan struktur folder Anda

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _database;
  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'db_buku');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Membuat tabel tb_buku sesuai model: id, judulbuku, kategori
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tb_buku (
        id INTEGER PRIMARY KEY,
        judulbuku TEXT,
        kategori TEXT
      )
    ''');
  }

  // Insert data buku
  Future<int> insertBuku(ModelBuku buku) async {
    Database db = await instance.db;
    return await db.insert('tb_buku', buku.toMap());
  }

  // Ambil semua data buku
  Future<List<Map<String, dynamic>>> queryAllBuku() async {
    Database db = await instance.db;
    return await db.query('tb_buku');
  }

  // Update data buku
  Future<int> updateBuku(ModelBuku buku) async {
    Database db = await instance.db;
    return await db.update('tb_buku', buku.toMap(), where: 'id = ?', whereArgs: [buku.id]);
  }

  // Hapus data buku
  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('tb_buku', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initializeDataBuku() async {
    final data = await queryAllBuku();
    if (data.isEmpty) {
      // Tambah data dummy kalau belum ada
      List<ModelBuku> dataBukuToAdd = [
        ModelBuku(judulbuku: 'Hii Miko', kategori: 'Komik'),
        ModelBuku(judulbuku: 'Scrambled 1', kategori: 'Komik'),
        ModelBuku(judulbuku: 'Raden Ajeng Kartini', kategori: 'Novel'),
        ModelBuku(judulbuku: 'Untukmu Anak Bungsu', kategori: 'Psikolog'),
        ModelBuku(judulbuku: 'Hidup Ini Terlalu Banyak Kamu', kategori: 'Novel'),
      ];

      for (ModelBuku buku in dataBukuToAdd) {
        await insertBuku(buku);
      }
    }
  }
}