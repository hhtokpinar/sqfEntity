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

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
class SqfEntityConnection {
  SqfEntityConnection(this.databaseName,
      {this.bundledDatabasePath,
      this.dbVersion = 1,
      this.password,
      this.databasePath});
  String databaseName;
  String? bundledDatabasePath;
  String? password;
  String? databasePath; // Option to set path at runtime.
  int dbVersion;
}

abstract class SqfEntityConnectionBase {
  SqfEntityConnectionBase(this.connection);
  static Map<String, Database>? dbMap;
  SqfEntityConnection? connection;
  Future<void> writeDatabase(ByteData data);
  Future<Database> openDb();
  void createDb(Database db, int version);

  Future<String> getFinalDatabasePath(String defaultDatabasePath) async {
    if(Platform.isWindows){
      final directory = dirname(Platform.script.toFilePath());
      return directory;
    }

    if (Platform.isLinux || Platform.isWindows) {
      final Directory supportDir = await getApplicationSupportDirectory();
      debugPrint(' Database Path : ${supportDir.path}');
      return supportDir.path;
    }

    if (connection!.databasePath == null) {
      return defaultDatabasePath;
    }
    String seperator = '/';
    if (Platform.isWindows) {
      seperator = '\\';
    }
    if (connection!.databasePath!
            .substring(connection!.databasePath!.length - 1) ==
        seperator) {
      return connection!.databasePath!;
    }
    return connection!.databasePath! + seperator;
  }
}
