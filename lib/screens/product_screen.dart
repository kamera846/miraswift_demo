import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/product_model.dart';
import 'package:miraswiftdemo/screens/formula_screen.dart';
import 'package:miraswiftdemo/services/product_api.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';
import 'package:miraswiftdemo/widgets/form_new_product.dart';
import 'package:miraswiftdemo/widgets/list_tile_item.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel>? _list;
  List<ProductModel> _listAccurate = [];
  bool _isLoading = true;
  ProductModel? _selectedItem;

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
    await ProductApi().list(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) {
            _list = data.reversed.toList();
          } else {
            _list = data;
          }
          _selectedItem = null;
        });
        _getListAccurate();
      },
    );
  }

  void _getListAccurate() async {
    setState(() {
      _isLoading = true;
    });
    await ProductApi().listAccurate(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) _listAccurate = data;
          _isLoading = false;

          _listAccurate.insert(
            0,
            const ProductModel.accurate(
              no: "-1",
              name: "== Select Product ==",
              id: -1,
            ),
          );
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
            child: FormNewProduct(
              listProduct: _listAccurate,
              onSubmitted: _submitNewItem,
            ),
          ),
        );
      },
    );
    // }
  }

  void _submitNewItem(String code, String name) async {
    setState(() {
      _isLoading = true;
    });
    await ProductApi().create(
      productCode: code,
      productName: name,
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
            child: FormNewProduct.edit(
              item: _selectedItem,
              listProduct: _listAccurate,
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

  void _submitEditItem(String code, String name) async {
    setState(() {
      _isLoading = true;
    });
    await ProductApi().edit(
      productId: _selectedItem!.idProduct,
      productCode: code,
      productName: name,
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
          'Are you sure you want to delete ${_selectedItem!.nameProduct} with code ${_selectedItem!.kodeProduct}?',
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
    await ProductApi().delete(
      productId: _selectedItem!.idProduct,
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
        title: Text(
          'Setting Recipe',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _newItem,
            icon: const Icon(CupertinoIcons.add_circled_solid),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.playlist_add_circle_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'List Product',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.withAlpha(75),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (!_isLoading && _list != null && _list!.isNotEmpty)
                    ? Column(
                        children: _list!.map((item) {
                          final isLastIndex = (index == (_list!.length - 1));
                          index++;
                          return Column(
                            children: [
                              ListTileItem(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          FormulaScreen(product: item),
                                    ),
                                  ).then((value) => _getList());
                                },
                                isSelected:
                                    (_selectedItem != null &&
                                        _selectedItem!.idProduct ==
                                            item.idProduct)
                                    ? true
                                    : false,
                                badge: item.kodeProduct,
                                title: item.nameProduct,
                                description: formattedDate(
                                  dateStr: item.createdAt,
                                ),
                                customTrailingIcon: PopupMenuButton<ProductModel>(
                                  icon: const Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (ctx) {
                                    return [
                                      PopupMenuItem<ProductModel>(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  FormulaScreen(product: item),
                                            ),
                                          ).then((value) => _getList());
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .arrow_up_right_circle_fill,
                                              color: Colors.blue.withAlpha(220),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            const Text('Open'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<ProductModel>(
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = item;
                                          });
                                          _editItem();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.pencil_circle_fill,
                                              color: Colors.orange.withAlpha(
                                                150,
                                              ),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            const Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<ProductModel>(
                                        onTap: () {
                                          setState(() {
                                            _selectedItem = item;
                                          });
                                          _deleteItem();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.trash_circle_fill,
                                              color: Colors.red.withAlpha(220),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            const Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ),
                              if (!isLastIndex)
                                Divider(height: 0, color: Colors.grey.shade300),
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
                                : !_isLoading &&
                                      (_list == null || _list!.isEmpty)
                                ? 'Data is empty.'
                                : '',
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
