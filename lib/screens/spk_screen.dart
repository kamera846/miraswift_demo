import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/models/spk_model.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/services/spk_api.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/form_new_spk.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';
import 'package:miraswift_demo/utils/platform_alert_dialog.dart';

class SpkScreen extends StatefulWidget {
  const SpkScreen({super.key});

  @override
  State<SpkScreen> createState() => _SpkScreenState();
}

class _SpkScreenState extends State<SpkScreen> {
  List<SpkModel>? _listPast;
  List<SpkModel>? _listNow;
  List<SpkModel>? _listUpcoming;
  List<ProductModel> _listProduct = [];
  bool _isLoading = true;
  SpkModel? _selectedItem;

  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _getListNow();
  }

  void _getListNow() async {
    setState(() {
      _isLoading = true;
    });
    await SpkApi().listByPeriod(
      period: 'now',
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listNow = data;
        });
        _getListUpcoming();
      },
    );
  }

  void _getListUpcoming() async {
    setState(() {
      _isLoading = true;
    });
    await SpkApi().listByPeriod(
      period: 'upcoming',
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listUpcoming = data;
        });
        _getListPast();
      },
    );
  }

  void _getListPast() async {
    setState(() {
      _isLoading = true;
    });
    await SpkApi().listByPeriod(
      period: 'past',
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listPast = data;
        });
        _getListProduct();
      },
    );
  }

  void _getListProduct() async {
    await ProductApi().list(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) _listProduct = data;
          _listProduct.insert(
            0,
            const ProductModel(
              kodeProduct: "-1",
              nameProduct: "== Select Product ==",
              idProduct: "-1",
              createdAt: "",
              updatedAt: "",
            ),
          );
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
            child: FormNewSpk(
                onSubmitted: _submitNewItem, listProduct: _listProduct),
          ),
        );
      },
    );
    // }
  }

  void _submitNewItem(
      String idProduct, String jmlBatch, String dateSpk, String descSpk) async {
    // print('$idProduct, $jmlBatch, $dateSpk, $descSpk');
    // return;
    setState(() {
      _isLoading = true;
    });
    await SpkApi().create(
      idProduct: idProduct,
      jmlBatch: jmlBatch,
      dateSpk: dateSpk,
      descSpk: descSpk,
      onSuccess: (msg) => showSnackBar(context, msg),
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: () {
        _getListNow();
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
            child: FormNewSpk.edit(
                item: _selectedItem,
                onSubmitted: _submitEditItem,
                listProduct: _listProduct),
          ),
        );
      },
    );
    setState(() {
      _selectedItem = null;
    });
    // }
  }

  void _submitEditItem(
      String idProduct, String jmlBatch, String dateSpk, String descSpk) async {
    // print('$idProduct, $jmlBatch, $dateSpk, $descSpk');
    // return;
    setState(() {
      _isLoading = true;
    });
    await SpkApi().edit(
      id: _selectedItem!.idSpk,
      idProduct: idProduct,
      jmlBatch: jmlBatch,
      dateSpk: dateSpk,
      descSpk: descSpk,
      onSuccess: (msg) => showSnackBar(context, msg),
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: () {
        _getListNow();
      },
    );
  }

  void _deleteItem() async {
    await showPlatformAlertDialog(
      context: context,
      title: 'Confirm Deletion',
      content:
          'Are you sure you want to delete ${_selectedItem!.descSpk} with total batch ${_selectedItem!.jmlBatch}?',
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
    await SpkApi().delete(
      id: _selectedItem!.idSpk,
      onSuccess: (msg) => showSnackBar(context, msg),
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: () {
        _getListNow();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('List SPK', style: Theme.of(context).textTheme.titleMedium),
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
            if (_isLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _isLoading
                        ? 'Loading..'
                        : !_isLoading &&
                                (_listNow == null || _listNow!.isEmpty) &&
                                (_listPast == null || _listPast!.isEmpty) &&
                                (_listUpcoming == null ||
                                    _listUpcoming!.isEmpty)
                            ? 'Data is empty.'
                            : '',
                  ),
                ),
              )
            else ...[
              _listNow != null && _listNow!.isNotEmpty
                  ? ListSpk(
                      title: 'Now',
                      listItem: _listNow!,
                      selectedItem: _selectedItem,
                      onEdit: (item) {
                        // print('Edit ${jsonEncode(item)}');
                        setState(() {
                          _selectedItem = item;
                        });
                        _editItem();
                      },
                      onDelete: (item) {
                        // print('Delete ${jsonEncode(item)}');
                        setState(() {
                          _selectedItem = item;
                        });
                        _deleteItem();
                      },
                    )
                  : const SizedBox.shrink(),
              _listUpcoming != null && _listUpcoming!.isNotEmpty
                  ? ListSpk(
                      title: 'Tomorrow',
                      listItem: _listUpcoming!,
                      selectedItem: _selectedItem,
                      onEdit: (item) {
                        setState(() {
                          _selectedItem = item;
                        });
                        _editItem();
                      },
                      onDelete: (item) {
                        setState(() {
                          _selectedItem = item;
                        });
                        _deleteItem();
                      },
                    )
                  : const SizedBox.shrink(),
              _listPast != null && _listPast!.isNotEmpty
                  ? ListSpk(
                      title: 'Yesterday',
                      listItem: _listPast!,
                      selectedItem: _selectedItem,
                      onEdit: (item) {
                        setState(() {
                          _selectedItem = item;
                        });
                        _editItem();
                      },
                      onDelete: (item) {
                        setState(() {
                          _selectedItem = item;
                        });
                        _deleteItem();
                      },
                    )
                  : const SizedBox.shrink(),
            ]
          ],
        ),
      ),
    );
  }
}

class ListSpk extends StatelessWidget {
  const ListSpk({
    super.key,
    required this.title,
    required this.listItem,
    this.selectedItem,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final List<SpkModel> listItem;
  final SpkModel? selectedItem;
  final Function(SpkModel item)? onEdit;
  final Function(SpkModel item)? onDelete;

  @override
  Widget build(BuildContext context) {
    var index = 0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            children: [
              const Icon(
                Icons.token_rounded,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleSmall),
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
          child: Column(
            children: listItem.map((item) {
              final isLastIndex = (index == (listItem.length - 1));
              index++;
              return Column(
                children: [
                  ListTileItem(
                    isSelected: (selectedItem != null &&
                            selectedItem!.idSpk == item.idSpk)
                        ? true
                        : false,
                    badge: '${item.jmlBatch} Batch',
                    title: item.descSpk,
                    description:
                        'Jadwal untuk tanggal ${formattedDate(dateStr: item.dateSpk)}',
                    customTrailingIcon: PopupMenuButton<SpkModel>(
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.grey,
                        ),
                        itemBuilder: (ctx) {
                          return [
                            PopupMenuItem<SpkModel>(
                              onTap: () {
                                onEdit!(item);
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
                            PopupMenuItem<SpkModel>(
                              onTap: () {
                                onDelete!(item);
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
          ),
        ),
      ],
    );
  }
}
