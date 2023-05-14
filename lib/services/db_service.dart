import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'cache_values.dart';

class DBService {
  Future<bool> openAssetDatabase() async {
    try {
      String path = join(await getDatabasesPath(), "ambulanceDB.db");
      var exists = await databaseExists(path);
      if (!exists) {
        debugPrint("Creating new copy from asset");
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}
        ByteData data = await rootBundle.load(join("assets", "ambulanceDB.db"));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } else {
        debugPrint("Opening existing database");
      }
      CachedModels.database = await openDatabase(path);
      return true;
    } catch(error, stacktrace) {
      debugPrint("Databasing opening error: $error, $stacktrace");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getData(String table, {String? query}) async {
    try {
      if(CachedModels.database != null) {
        return await CachedModels.database!.rawQuery(query ?? "SELECT * FROM $table;");
      } else {
        debugPrint("Database is null!");
        return [];
      }
    } catch(error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return [];
    }
  }


  Future<bool> writeDataToDB(String table, Map<String, dynamic> body) async {
    try{
      if(CachedModels.database != null) {
        try{
          await CachedModels.database!.insert(table, body);
          getData(table);
          return true;
        } catch (error, stacktrace) {
          debugPrint("Add word error: $error, $stacktrace");
          return false;
        }
      } else {
        debugPrint("Database is null!");
        return false;
      }
    } catch (error, stacktrace) {
      debugPrint("$error, $stacktrace");
      return false;
    }
  }
}