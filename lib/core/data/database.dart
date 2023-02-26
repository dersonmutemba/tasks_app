import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app/core/data/constants.dart';

class LocalDatabase {
  late Database db;
  final String query;
  LocalDatabase(this.query, {Database? database}) {
    if(database != null) {
      db = database;
    }
  }

  Future initialize() async {
    final String path = (await getLibraryDirectory()).path + dbName;
    db = await openDatabase(path, version: dbVersion);
    db.execute(query);
  }

  Future insert(String table, List<Map<String, dynamic>> valuesList) async {
    Batch batch = db.batch();
    for (var values in valuesList) {
      batch.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>?> getObjects(
      String table,
      List<String> selectionColumns,
      List<dynamic> selectionValues,
      List<String> otherColumns) async {
    List<Map> maps = await db.query(table,
        columns: selectionColumns + otherColumns,
        where: _generateWhere(selectionColumns),
        whereArgs: selectionValues);
    if (maps.isNotEmpty) {
      List<Map<String, dynamic>> result = maps
          .map(
              (map) => map.map((key, value) => MapEntry(key.toString(), value)))
          .toList();
      return result;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAllObjects(
      String table) async {
    List<Map> maps = await db.query(table);
    if (maps.isNotEmpty) {
      List<Map<String, dynamic>> result = maps
          .map(
              (map) => map.map((key, value) => MapEntry(key.toString(), value)))
          .toList();
      return result;
    }
    return null;
  }

  Future<int> delete(String table, List<String> selectionColumns,
      List<dynamic> selectionValues) async {
    return await db.delete(table,
        where: _generateWhere(selectionColumns), whereArgs: selectionValues);
  }

  Future<int> update(String table, Map<String, dynamic> values,
      List<String> selectionColumns, List<dynamic> selectionValues) async {
    return await db.update(table, values,
        where: _generateWhere(selectionColumns), whereArgs: selectionValues);
  }

  String _generateWhere(List<String> fields) {
    String where = '';
    for (int i = 0; i + 1 < fields.length; i++) {
      where += '${fields[i]} = ?, ';
    }
    return '$where${fields.last} = ?';
  }

  Future finalize() async => db.close();
}
