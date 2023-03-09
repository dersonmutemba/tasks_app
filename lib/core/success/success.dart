abstract class Success {
  final List<dynamic>? properties;
  Success([this.properties]);

  @override
  bool operator ==(Object other) =>
      other is Success && other.runtimeType == runtimeType;

  @override
  int get hashCode => properties.hashCode;
      
}

class InsertionSuccess extends Success {}

class RemoteInsertionSuccess extends Success {}

class UpdateSuccess extends Success {}

class RemoteUpdateSuccess extends Success {}
