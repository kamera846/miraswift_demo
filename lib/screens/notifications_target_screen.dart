import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/user_model.dart';
import 'package:miraswift_demo/services/user_api.dart';
import 'package:miraswift_demo/utils/badge.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/form_new_notification_target.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';
import 'package:miraswift_demo/utils/platform_alert_dialog.dart';

class NotificationsTargetScreen extends StatefulWidget {
  const NotificationsTargetScreen({super.key});

  @override
  State<NotificationsTargetScreen> createState() =>
      _NotificationsTargetScreenState();
}

class _NotificationsTargetScreenState extends State<NotificationsTargetScreen> {
  List<UserModel>? _list;
  bool _isLoading = true;
  UserModel? _selectedItem;

  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() async {
    setState(() {
      _isLoading = true;
    });
    await UserApi().list(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _list = data;
          _selectedItem = null;
          _isLoading = false;
        });
      },
    );
  }

  void _newItem() {
    // if (Platform.isIOS) {
    //   showCupertinoModalPopup(
    //     context: context,
    //     builder: (ctx) {
    //       return CupertinoPopupSurface(
    //         isSurfacePainted: false,
    //         child: Material(
    //           color: Colors.transparent,
    //           borderRadius: BorderRadius.circular(24),
    //           child: GestureDetector(
    //             onTap: () {
    //               Navigator.pop(context);
    //             },
    //             child: Container(
    //               color: Colors.transparent,
    //               height: double.infinity,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                       color: CupertinoTheme.of(context)
    //                           .scaffoldBackgroundColor,
    //                       borderRadius: BorderRadius.circular(24),
    //                     ),
    //                     padding: const EdgeInsets.all(12),
    //                     child: FormNewProduct(
    //                       onSubmitted: _submitNewItem,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // } else {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12 + _keyboardHeight,
            ),
            child: FormNewNotificationTarget(
              onSubmitted: _submitNewItem,
            ),
          ),
        );
      },
    );
    // }
  }

  void _submitNewItem(String name, String phone, String status) async {
    setState(() {
      _isLoading = true;
    });
    await UserApi().create(
      phoneUser: phone,
      nameUser: name,
      isActive: status,
      onSuccess: (msg) => showSnackBar(context, msg),
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: () {
        _getList();
      },
    );
  }

  void _editItem() async {
    // if (Platform.isIOS) {
    //   await showCupertinoModalPopup(
    //     context: context,
    //     builder: (ctx) {
    //       return CupertinoPopupSurface(
    //         isSurfacePainted: false,
    //         child: Material(
    //           color: Colors.transparent,
    //           borderRadius: BorderRadius.circular(24),
    //           child:   (
    //             onTap: () {
    //               Navigator.pop(context);
    //             },
    //             child: Container(
    //               color: Colors.transparent,
    //               height: double.infinity,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                       color: CupertinoTheme.of(context)
    //                           .scaffoldBackgroundColor,
    //                       borderRadius: BorderRadius.circular(24),
    //                     ),
    //                     padding: const EdgeInsets.all(12),
    //                     child: FormNewProduct.edit(
    //                       item: _selectedItem,
    //                       onSubmitted: _submitEditItem,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    //   setState(() {
    //     _selectedItem = null;
    //   });
    // } else {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12 + _keyboardHeight,
            ),
            child: FormNewNotificationTarget.edit(
              item: _selectedItem,
              onSubmitted: _submitEditItem,
            ),
          ),
        );
      },
    );
    setState(() {
      _selectedItem = null;
    });
    // }
  }

  void _submitEditItem(String phone, String name, String status) async {
    setState(() {
      _isLoading = true;
    });
    await UserApi().edit(
      id: _selectedItem!.idUser,
      nameUser: name,
      phoneUser: phone,
      isActive: status,
      onSuccess: (msg) => showSnackBar(context, msg),
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: () {
        _getList();
      },
    );
  }

  void _deleteItem() async {
    await showPlatformAlertDialog(
      context: context,
      title: 'Confirm Deletion',
      content:
          'Are you sure you want to delete ${_selectedItem!.nameUser} with number ${_selectedItem!.phoneUser}?',
      positiveButtonText: 'Delete',
      positiveButtonTextColor: CupertinoColors.systemRed,
      onPositivePressed: _submitDeleteItem,
      negativeButtonText: 'Cancel',
      onNegativePressed: () {
        setState(() {
          _selectedItem = null;
        });
        Navigator.of(context).pop();
      },
    );
    setState(() {
      _selectedItem = null;
    });
  }

  void _submitDeleteItem() async {
    Navigator.of(context).pop();
    setState(() {
      _isLoading = true;
    });
    await UserApi().delete(
      id: _selectedItem!.idUser,
      onSuccess: (msg) => showSnackBar(context, msg),
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: () {
        _getList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    int index = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Target',
            style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _newItem,
            icon: const Icon(
              CupertinoIcons.add_circled_solid,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List User',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (!_isLoading && _list != null && _list!.isNotEmpty)
                  ? Column(
                      children: _list!.map((item) {
                        bool isUserActive = item.isActive == "1";
                        final isLastIndex = (index == (_list!.length - 1));
                        index++;
                        return Column(
                          children: [
                            ListTileItem(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (ctx) =>
                                //         FormulaScreen(product: item),
                                //   ),
                                // );
                              },
                              isSelected: (_selectedItem != null &&
                                      _selectedItem!.idUser == item.idUser)
                                  ? true
                                  : false,
                              badge: isUserActive ? "Active" : "Inactive",
                              badgeModel: BadgeModel(
                                isUserActive
                                    ? badgeStyle[BadgeCategory.green]!.txtColor
                                    : badgeStyle[BadgeCategory.grey]!.txtColor,
                                isUserActive
                                    ? badgeStyle[BadgeCategory.green]!.bgColor
                                    : badgeStyle[BadgeCategory.grey]!.bgColor,
                              ),
                              title: item.nameUser,
                              description: item.phoneUser,
                              customTrailingIcon: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (ctx) {
                                    return [
                                      // PopupMenuItem<String>(
                                      //   onTap: () {
                                      //     // Navigator.push(
                                      //     //   context,
                                      //     //   MaterialPageRoute(
                                      //     //     builder: (ctx) =>
                                      //     //         FormulaScreen(product: item),
                                      //     //   ),
                                      //     // );
                                      //   },
                                      //   child: const Row(
                                      //     children: [
                                      //       Icon(
                                      //         CupertinoIcons
                                      //             .arrow_up_right_circle_fill,
                                      //         size: 20,
                                      //       ),
                                      //       SizedBox(width: 12),
                                      //       Text('Open')
                                      //     ],
                                      //   ),
                                      // ),
                                      PopupMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = item;
                                          });
                                          _editItem();
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.pencil_circle_fill,
                                              size: 20,
                                            ),
                                            SizedBox(width: 12),
                                            Text('Edit')
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = item;
                                          });
                                          _deleteItem();
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.trash_circle_fill,
                                              size: 20,
                                            ),
                                            SizedBox(width: 12),
                                            Text('Delete')
                                          ],
                                        ),
                                      ),
                                    ];
                                  }),
                            ),
                            if (!isLastIndex)
                              Divider(
                                height: 0,
                                color: Colors.grey.shade300,
                              ),
                          ],
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _isLoading
                              ? 'Loading..'
                              : !_isLoading && (_list == null || _list!.isEmpty)
                                  ? 'Data is empty.'
                                  : '',
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
