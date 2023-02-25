// Mocks generated by Mockito 5.3.2 from annotations
// in tasks_app/test/core/data/database_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:sqflite/sqflite.dart' as _i2;
import 'package:tasks_app/core/data/database.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LocalDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalDatabase extends _i1.Mock implements _i3.LocalDatabase {
  MockLocalDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Database get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.getter(#db),
        ),
      ) as _i2.Database);
  @override
  set db(_i2.Database? _db) => super.noSuchMethod(
        Invocation.setter(
          #db,
          _db,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get query => (super.noSuchMethod(
        Invocation.getter(#query),
        returnValue: '',
      ) as String);
  @override
  _i4.Future<dynamic> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i4.Future<dynamic> insert(
    String? table,
    Map<String, dynamic>? values,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #insert,
          [
            table,
            values,
          ],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
  @override
  _i4.Future<List<Map<dynamic, dynamic>>?> getObjects(
    String? table,
    List<String>? selectionColumns,
    List<dynamic>? selectionValues,
    List<String>? otherColumns,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getObjects,
          [
            table,
            selectionColumns,
            selectionValues,
            otherColumns,
          ],
        ),
        returnValue: _i4.Future<List<Map<dynamic, dynamic>>?>.value(),
      ) as _i4.Future<List<Map<dynamic, dynamic>>?>);
  @override
  _i4.Future<int> delete(
    String? table,
    List<String>? selectionColumns,
    List<dynamic>? selectionValues,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [
            table,
            selectionColumns,
            selectionValues,
          ],
        ),
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<int> update(
    String? table,
    Map<String, dynamic>? values,
    List<String>? selectionColumns,
    List<dynamic>? selectionValues,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [
            table,
            values,
            selectionColumns,
            selectionValues,
          ],
        ),
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<dynamic> finalize() => (super.noSuchMethod(
        Invocation.method(
          #finalize,
          [],
        ),
        returnValue: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);
}
