import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<void> showPlatformAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  bool surfacePainted = false,
  required String positiveButtonText,
  required void Function() onPositivePressed,
  String? negativeButtonText,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: surfacePainted
                      ? null
                      : BoxDecoration(
                          color: CupertinoTheme.of(context)
                              .scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (negativeButtonText != null)
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: surfacePainted
                          ? null
                          : CupertinoTheme.of(context).scaffoldBackgroundColor,
                      onPressed: onNegativePressed,
                      child: Text(
                        negativeButtonText,
                        style:
                            const TextStyle(color: CupertinoColors.systemBlue),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: surfacePainted
                        ? null
                        : CupertinoTheme.of(context).scaffoldBackgroundColor,
                    onPressed: onPositivePressed,
                    child: Text(
                      positiveButtonText,
                      style: const TextStyle(color: CupertinoColors.systemBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // child: CupertinoAlertDialog(
          //   title: Text(title),
          //   content: Text(content),
          //   actions: [
          //     if (negativeButtonText != null)
          //       CupertinoDialogAction(
          //         onPressed: onNegativePressed,
          //         child: Text(negativeButtonText),
          //       ),
          //     CupertinoDialogAction(
          //       onPressed: onPositivePressed,
          //       child: Text(positiveButtonText),
          //     ),
          //   ],
          // ),
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
