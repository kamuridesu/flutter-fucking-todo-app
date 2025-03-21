import 'package:flutter/material.dart';

TextButton cancelButton(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.of(context).pop(),
    child: Text("Cancel"),
  );
}

TextButton saveButton(BuildContext context, VoidCallback onPressed) {
  return TextButton(onPressed: onPressed, child: Text("Save"));
}
