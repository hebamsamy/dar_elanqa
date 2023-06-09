import 'package:flutter/material.dart';

showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String defaultActionText,
  required VoidCallback onOkPressed,
  String? optinalActionText,
  VoidCallback? optinalPressed,
  required bool show,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        OutlinedButton(
          onPressed: onOkPressed,
          child: Text(defaultActionText),
        ),
        show
            ? OutlinedButton(
                onPressed: optinalPressed!,
                child: Text(optinalActionText!),
              )
            : SizedBox(),
      ],
    ),
  );
}
