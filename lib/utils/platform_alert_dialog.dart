import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<void> showPlatformAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  bool surfacePainted = false,
  required String positiveButtonText,
  Color? positiveButtonTextColor,
  required void Function() onPositivePressed,
  String? negativeButtonText,
  Color? negativeButtonTextColor,
  void Function()? onNegativePressed,
}) async {
  if (Platform.isIOS) {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPopupSurface(
          isSurfacePainted: surfacePainted,
          child: Container(
            height: surfacePainted ? 240 : double.infinity,
            padding: const EdgeInsets.all(8),
            child: CupertinoActionSheet(
              message: Column(
                children: [
                  Text(
                    title,
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                if (negativeButtonText != null && onNegativePressed != null)
                  CupertinoActionSheetAction(
                    onPressed: onNegativePressed,
                    child: Text(
                      negativeButtonText,
                      style: TextStyle(
                        color: negativeButtonTextColor ??
                            CupertinoColors.systemBlue,
                      ),
                    ),
                  ),
                CupertinoActionSheetAction(
                  onPressed: onPositivePressed,
                  child: Text(
                    positiveButtonText,
                    style: TextStyle(
                      color:
                          positiveButtonTextColor ?? CupertinoColors.systemBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  } else {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (negativeButtonText != null)
              TextButton(
                onPressed: onNegativePressed,
                child: Text(negativeButtonText),
              ),
            TextButton(
              onPressed: onPositivePressed,
              child: Text(positiveButtonText),
            ),
          ],
        );
      },
    );
  }
}
