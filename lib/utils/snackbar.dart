import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  // if (Platform.isIOS) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (ctx) {
  //       return CupertinoActionSheet(
  //         message: Text(
  //           message,
  //           style: CupertinoTheme.of(context).textTheme.textStyle,
  //         ),
  //         actions: [
  //           CupertinoActionSheetAction(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               'Dismiss',
  //               style: TextStyle(color: CupertinoColors.systemBlue),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // } else {
  Duration duration = const Duration(seconds: 3);
  if (message.length > 25) {
    duration = const Duration(seconds: 4);
  } else if (message.length > 50) {
    duration = const Duration(seconds: 5);
  }
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
    ),
  );
  // }
}
