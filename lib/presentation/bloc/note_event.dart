import 'package:meta/meta.dart';

@immutable
abstract class NoteEvent {
  final List props;
  const NoteEvent([this.props = const <dynamic>[]]);

  @override
  bool operator == (Object other) =>
    other is NoteEvent &&
    other.runtimeType == runtimeType &&
    other.props == props;
  
  @override
  int get hashCode => props.hashCode;
}

