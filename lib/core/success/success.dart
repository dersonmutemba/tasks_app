import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  final List<dynamic>? properties;
  const Success([this.properties]);

  @override
  List<Object?> get props => [properties];
}

class InsertionSuccess extends Success {
}

class RemoteInsertionSuccess extends Success {}

class UpdateSuccess extends Success {}

class RemoteUpdateSuccess extends Success {}
