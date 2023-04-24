import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  final List<dynamic>? properties;
  const Success([this.properties]);

  @override
  List<Object?> get props => [properties];
}

class InsertionSuccess extends Success {
  final String id;
  InsertionSuccess({required this.id}) : super([id]);
}

class RemoteInsertionSuccess extends Success {
  final String id;
  RemoteInsertionSuccess({required this.id}) : super([id]);
}

class UpdateSuccess extends Success {}

class RemoteUpdateSuccess extends Success {}

class RemoteDeleteSuccess extends Success {}

class DeleteSuccess extends Success {}
