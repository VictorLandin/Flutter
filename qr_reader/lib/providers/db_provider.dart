

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {

    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    print(path);

    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Scans('
            'id INTEGER PRIMARY KEY,'
            'tipo TEXT,'
            'valor TEXT'
            ')');
      },
    );
  }

  Future<int> nuevoScan( ScanModel nuevoScan) async{

    final db = await database;
    final res = await db!.insert('Scans', nuevoScan.toJson());
    return res;
  }


  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db?.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res?.isNotEmpty == true ? ScanModel.fromJson(res!.first) : null;
  }

}

