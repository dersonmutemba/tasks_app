import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  @override
  bool operator ==(Object other) =>
      other is NoParams && other.runtimeType == runtimeType;
      
  @override
  int get hashCode => runtimeType.hashCode;
      
}
