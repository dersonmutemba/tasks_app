// Mocks generated by Mockito 5.3.2 from annotations
// in tasks_app/test/domain/usecases/test_contract_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:tasks_app/core/error/failure.dart' as _i5;
import 'package:tasks_app/core/success/success.dart' as _i6;
import 'package:tasks_app/domain/contracts/task_contract.dart' as _i3;
import 'package:tasks_app/domain/entities/task.dart' as _i7;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TaskContract].
///
/// See the documentation for Mockito's code generation for more information.
class MockTaskContract extends _i1.Mock implements _i3.TaskContract {
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Success>> insertTask(_i7.Task? task) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertTask,
          [task],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Success>>.value(
            _FakeEither_0<_i5.Failure, _i6.Success>(
          this,
          Invocation.method(
            #insertTask,
            [task],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Success>>.value(
                _FakeEither_0<_i5.Failure, _i6.Success>(
          this,
          Invocation.method(
            #insertTask,
            [task],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Success>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i7.Task>>> getTasks() =>
      (super.noSuchMethod(
        Invocation.method(
          #getTasks,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, List<_i7.Task>>>.value(
            _FakeEither_0<_i5.Failure, List<_i7.Task>>(
          this,
          Invocation.method(
            #getTasks,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i7.Task>>>.value(
                _FakeEither_0<_i5.Failure, List<_i7.Task>>(
          this,
          Invocation.method(
            #getTasks,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i7.Task>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i7.Task>> getTask(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTask,
          [id],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i7.Task>>.value(
            _FakeEither_0<_i5.Failure, _i7.Task>(
          this,
          Invocation.method(
            #getTask,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i7.Task>>.value(
                _FakeEither_0<_i5.Failure, _i7.Task>(
          this,
          Invocation.method(
            #getTask,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i7.Task>>);
}