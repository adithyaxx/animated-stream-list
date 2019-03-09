import 'package:flutter/material.dart';

typedef void Action();

class SnackBarFactory {
  SnackBar create(String content) {
    return SnackBar(
      content: Text(content),
    );
  }

  SnackBar createWithAction({String content, String label, Action action}) {
    return SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: label,
        onPressed: () => action(),
      ),
    );
  }
}
