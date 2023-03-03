import 'package:meta/meta.dart';

@immutable
abstract class NoteState {
  final List props;
  const NoteState([this.props = const <dynamic>[]]);

  @override
  bool operator ==(Object other) =>
      other is NoteState &&
      other.runtimeType == runtimeType &&
      other.props == props;

  @override
  int get hashCode => props.hashCode;
}

class Empty extends NoteState {}

class Error extends NoteState {
  final String message;
  Error({required this.message}) : super([message]);

  @override
  bool operator ==(Object other) =>
    other is Error &&
    other.runtimeType == runtimeType &&
    other.message == message &&
    other.props == props;
  
  @override
  int get hashCode => (props.toString() + message).hashCode;
}

class Loaded extends NoteState {}

class Loading extends NoteState {}
