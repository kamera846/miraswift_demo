import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/form_new_product.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';
import 'package:miraswift_demo/utils/platform_alert_dialog.dart';

class FormulaScreen extends StatefulWidget {
  const FormulaScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen> {
  List<ProductModel>? _list;
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
    //                     padding: const EdgeInsets.all(16),
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
              left: 16,
              right: 16,
              bottom: 16 + _keyboardHeight,
            ),
            child: FormNewProduct(
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
    //                     padding: const EdgeInsets.all(16),
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
              left: 16,
              right: 16,
              bottom: 16 + _keyboardHeight,
            ),
            child: FormNewProduct.edit(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.nameProduct,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              widget.product.kodeProduct,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
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
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.receipt_rounded,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List Formula',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
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
                              onTap: () {},
                              isSelected: (_selectedItem != null &&
                                      _selectedItem!.idProduct ==
                                          item.idProduct)
                                  ? true
                                  : false,
                              badge: item.kodeProduct,
                              title: item.nameProduct,
                              description: item.createdAt,
                              customTrailingIcon: PopupMenuButton<ProductModel>(
                                  icon: const Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (ctx) {
                                    return [
                                      PopupMenuItem<ProductModel>(
                                        onTap: () async {
                                          await Future.delayed(const Duration(
                                              milliseconds: 250));
                                          setState(() {
                                            _selectedItem = null;
                                          });
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons
                                                  .arrow_up_right_circle_fill,
                                              size: 20,
                                            ),
                                            SizedBox(width: 12),
                                            Text('Open')
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
                                      PopupMenuItem<ProductModel>(
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
                                color: Colors.grey.withAlpha(75),
                              ),
                          ],
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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