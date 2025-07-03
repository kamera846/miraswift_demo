import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        return CupertinoActionSheet(
          title: Text(
            title,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          message: Text(
            content,
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
          actions: [
            if (negativeButtonText != null && onNegativePressed != null)
              CupertinoActionSheetAction(
                onPressed: onNegativePressed,
                child: Text(
                  negativeButtonText,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .actionTextStyle
                      .copyWith(
                          color: negativeButtonTextColor ??
                              CupertinoColors.systemBlue),
                ),
              ),
            CupertinoActionSheetAction(
              onPressed: onPositivePressed,
              child: Text(
                positiveButtonText,
                style: CupertinoTheme.of(context)
                    .textTheme
                    .actionTextStyle
                    .copyWith(
                        color: positiveButtonTextColor ??
                            CupertinoColors.systemBlue),
              ),
            ),
          ],
        );
      },
    );
  } else {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            content,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          actions: [
            if (negativeButtonText != null)
              TextButton(
                onPressed: onNegativePressed,
                child: Text(
                  negativeButtonText,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: negativeButtonTextColor ??
                            Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            TextButton(
              onPressed: onPositivePressed,
              child: Text(
                positiveButtonText,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: positiveButtonTextColor ??
                          Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
