import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class LocalDatabase {
  late Database db;
  final String query;
  LocalDatabase(this.query, {Database? database}) {
    if (database != null) {
      db = database;
    } else {
      initialize();
    }
  }

  Future initialize() async {
    String directory = Platform.isIOS
        ? (await getLibraryDirectory()).path
        : await getDatabasesPath();
    final String path = '$directory/$dbName';
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

  Future<List<Map<String, dynamic>>?> searchObjects(
      String table,
      List<String> searchColumns,
      String searchQuery,
      List<String> otherColumns) async {
    Batch batch = db.batch();
    batch.query(
      table,
      columns: searchColumns + otherColumns,
      where: _generateWhere(searchColumns),
      whereArgs: List.generate(searchColumns.length, (index) => searchQuery),
    );
    batch.query(
      table,
      columns: searchColumns + otherColumns,
      where: _generateWhere(searchColumns, whereOperator: 'LIKE'),
      whereArgs:
          List.generate(searchColumns.length, (index) => '%$searchQuery%'),
    );
    batch.query(
      table,
      columns: searchColumns + otherColumns,
      where:
          _generateWhere(searchColumns, operator: 'OR', whereOperator: 'LIKE'),
      whereArgs:
          List.generate(searchColumns.length, (index) => '%$searchQuery%'),
    );
    List<dynamic> commit = await batch.commit();
    List<Map> maps = [];
    for (var batchresult in commit) {
      Map map = {};
      if (batchresult.isNotEmpty) {
      for (int i = 0; i < batchresult.first.length; i++) {
        map.addAll({batchresult.first.keys[i]: batchresult.first.row[i]});
      }
        if (!_mapContains(maps, map)) {
        maps.add(map);
        }
      }
    }
    if (maps.isNotEmpty) {
      List<Map<String, dynamic>> result = maps
          .map(
              (map) => map.map((key, value) => MapEntry(key.toString(), value)))
          .toList();
      return result;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAllObjects(String table) async {
    List<Map> maps = await db.query(table);
    if (maps.isNotEmpty) {
      List<Map<String, dynamic>> result = maps
          .map(
              (map) => map.map((key, value) => MapEntry(key.toString(), value)))
          .toList();
      return result;
    }
    return [];
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

  String _generateWhere(List<String> fields,
      {String operator = 'AND', String whereOperator = '='}) {
    String where = '';
    for (int i = 0; i + 1 < fields.length; i++) {
      where += '${fields[i]} $whereOperator ? $operator ';
    }
    return '$where${fields.last} $whereOperator ?';
  }

  bool _mapContains(List<Map> maps, Map map) {
    for (var element in maps) {
      if (mapEquals(element, map)) {
        return true;
      }
    }
    return false;
  }

  Future finalize() async => db.close();
}
