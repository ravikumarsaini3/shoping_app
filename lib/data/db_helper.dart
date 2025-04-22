import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoping_app/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper getInstance = DbHelper._();
  Database? _myDb;

  Future<Database> getDb() async {
    if (_myDb != null) {
      return _myDb!;
    } else {
      _myDb = await openDb();
      return _myDb!;
    }
  }

  Future<Database> openDb() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    String dirPath = join(dir.path, 'cart.db');
    return openDatabase(
        dirPath,
        onCreate: (db, version) {
          db.execute(
            'create table cart (id integer primary key autoincrement ,productId integer unique, productName text,productPrice real,quantity integer,productBasePrice real,productImage text,productUnit text  )',
          );
        },
        version: 1
    );
  }

  Future<bool> insertData(CartModel cartModel) async {
    final myDb = await getDb();
    int rowEffect = await myDb.insert('cart', cartModel.toMap(),

      conflictAlgorithm: ConflictAlgorithm.replace,);

    return rowEffect > 0;
  }

  Future<List<CartModel>> getListData() async {
    final myDb = await getDb();
    List<Map<String, dynamic>> list = await myDb.query('cart');
    return list.map((e) => CartModel.fromMap(e)).toList();
  }

  Future<bool> deleteData(int id) async {
    final myDb = await getDb();
    int rowEffect = await myDb.delete('cart', where: 'id=?', whereArgs: [id]);
    return rowEffect > 0;
  }
  Future<void> updateBasePrice(int id, double basePrice) async {
    final db = await getDb();
    await db.update(
      'cart',
      {'productBasePrice': basePrice},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> updateQuantity(int id, int quantity) async {
    final myDb = await getDb();
    int rowEffect = await myDb.update(
        'cart', {'quantity': quantity}, where: 'id=?', whereArgs: [id]);
    return rowEffect > 0;
  }
}