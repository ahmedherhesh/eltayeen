import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DB {
  Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initalDB();
      return _db;
    } else {
      return _db;
    }
  }

  initalDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'soldiers_food.db');
    Database db = await openDatabase(path, onCreate: onCreate, version: 1);
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute('''
                  CREATE TABLE users (
                    `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
                    `username` TEXT NULL,
                    `fullname` TEXT NOT NULL, 
                    `role` TEXT NULL
                  );
                ''');
    await db.execute('''
                  CREATE TABLE items (
                    `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
                    `title` TEXT NOT NULL
                  );
                ''');
    await db.execute('''
                  CREATE TABLE transactions (
                    `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
                    `adminId` INTEGER NOT NULL,
                    `userId` INTEGER NOT NULL, 
                    `itemId` INTEGER NOT NULL, 
                    `qty` INTEGER NOT NULL,
                    `date` DATE NULL
                  );
                ''');
    // ignore: avoid_print
    print('created');
  }

  get({required String table, Map? where, String? join}) async {
    String sql = 'SELECT * FROM $table ';
    
    if (join != null) {
      sql += ' $join ';
    }
    if (where != null) {
      int counter = 1;
      sql += ' WHERE ';
      where.forEach((key, value) {
        sql += "$key='$value'";
        if (where.length > counter) {
          sql += ' AND ';
          counter++;
        }
      });
    }

    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insert({required String table, required Map data}) async {
    Database? mydb = await db;
    String sql = 'INSERT INTO $table ';
    sql += '(${data.keys.toList().join(',')})';
    sql += ' VALUES ';
    data.forEach((key, value) {
      data[key] = "'$value'";
    });
    sql += '(${data.values.toList().join(',')})';
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  update(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  delete(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
