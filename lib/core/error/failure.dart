abstract class Failure {
  final List<dynamic>? properties;
  Failure([this.properties]);

  @override
  bool operator ==(Object other) =>
      other is Failure &&
      other.runtimeType == runtimeType &&
      other.properties == properties;

  @override
  int get hashCode => properties.hashCode;
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class EmptyNoteFailure extends Failure {}
