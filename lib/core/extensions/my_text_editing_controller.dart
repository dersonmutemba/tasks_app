import 'package:flutter/widgets.dart';

class MyTextEditingController extends TextEditingController {
  late List<String> textList;
  int position = -1;
  String? pastText;
  var operation = _MyTextEditingControllerOperations();
  MyTextEditingController() : super() {
    textList = [];
  }

  bool canUndo() => position > 0;

  void undo() {
    operation = _Undo();
    if (canUndo()) {
      super.text = textList[--position];
    }
  }

  bool canRedo() => position < textList.length - 1;

  void redo() {
    operation = _Redo();
    if (canRedo()) {
      super.text = textList[++position];
    }
  }

  @override
  set text(String newText) {
    if (operation is! _Redo && operation is! _Undo) {
      pastText = text;
    }
    super.text = newText;
  }

  @override
  void addListener(VoidCallback listener) {
    if(text == '' && textList.isEmpty) {
      textList.add('');
      position++;
    }
    if (pastText != text && operation is! _Redo && operation is! _Undo) {
      if (canRedo()) {
        textList.removeRange(position + 1, textList.length);
      }
      textList.add(super.text);
      position++;
    }
    pastText = text;
    operation = _MyTextEditingControllerOperations();
    super.addListener(listener);
  }
}

class _MyTextEditingControllerOperations {}

class _Undo extends _MyTextEditingControllerOperations {}

class _Redo extends _MyTextEditingControllerOperations {}
