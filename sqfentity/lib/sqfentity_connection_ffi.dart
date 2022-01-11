//                           LICENSE

//    Copyright (C) 2019, HUSEYIN TOKPUNAR http://huseyintokpinar.com/

//    Download & Update Latest Version: https://github.com/hhtokpinar/sqfEntity

//    Licensed under the Apache License, Version 2.0 (the 'License');
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an 'AS IS' BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqfentity/sqfentity_connection_base.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronized/synchronized.dart';

// BEGIN DATABASE CONNECTION
class SqfEntityConnectionFfi extends SqfEntityConnectionBase {
  SqfEntityConnectionFfi(SqfEntityConnection? connection) : super(connection);

  @override
  Future<void> writeDatabase(ByteData data) async {
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    try {
      final databaseFactory = databaseFactoryFfi;
      sqfliteFfiInit();
      final path = join(
          getFinalDatabasePath(await databaseFactory.getDatabasesPath()),
          connection!.databaseName);
      if (File(path).existsSync()) {
        await databaseFactory.deleteDatabase(path);
        if (File('$path-wal').existsSync()) {
          File('$path-wal').deleteSync();
        }
      }
      File(path).writeAsBytesSync(bytes, mode: FileMode.write);
      print('The database has been written to $path successfully');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// When the software/app is started, sqfentity checks the database was it initialized. If needed, initilizeDb method runs that CREATE TABLE / ALTER TABLE ADD COLUMN queries for you.
  @override
  Future<Database> openDb() async {
    final lock = Lock();
    Database? _db;
    await lock.synchronized(() async {
      final databaseFactory = databaseFactoryFfi;
      sqfliteFfiInit();
      final path = join(
          getFinalDatabasePath(await databaseFactory.getDatabasesPath()),
          connection!.databaseName);
      final file = File(path);

      // check if file exists
      if (!file.existsSync()) {
        // Copy from asset if MyDbModel.bundledDatabasePath is not empty
        if (connection!.bundledDatabasePath != null &&
            connection!.bundledDatabasePath != '' &&
            connection!.bundledDatabasePath != 'null') {
          final ByteData data =
              await rootBundle.load(connection!.bundledDatabasePath!);
          await writeDatabase(data);
        }
      }

      // uncomment line below if you want to use sqlchiper
      // _db = await openDatabase(path, version: 1, onCreate: _createDb, password: _dbModel.password); // SQLChipher

      // uncomment line below if you want to use sqflite
      // _db = await openDatabase(path, version: 1, onCreate: _createDb); // SQFLite
      //} else {

      _db = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
            version: connection!.dbVersion,
            onCreate: createDb,
            onConfigure: (db) async {
              if (connection!.password != null) {
                //https://github.com/davidmartos96/sqflite_sqlcipher/issues/28
                await db.rawQuery("PRAGMA KEY='${connection!.password!}'");
              }
            },
          ));
      //  }
    });
    //}
    return _db!;
  }

  /// Creates db if not exist
  @override
  void createDb(Database db, int version) async {
    await db.execute(
        'Create table sqfentitytables (id integer primary key, tablename text, version int, properties text)');
    await db.execute(
        'Create table sqfentitysequences (id text UNIQUE, value integer)');
    print(
        'Your database ${connection!.databaseName} v:$version created successfully');
  }
}
