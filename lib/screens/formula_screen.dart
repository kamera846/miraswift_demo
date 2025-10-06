import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/formula_model.dart';
import 'package:miraswiftdemo/models/material_model.dart';
import 'package:miraswiftdemo/models/product_model.dart';
import 'package:miraswiftdemo/services/formula_api.dart';
import 'package:miraswiftdemo/services/material_api.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';
import 'package:miraswiftdemo/widgets/form_new_formula.dart';
import 'package:miraswiftdemo/widgets/list_tile_item.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';

class FormulaScreen extends StatefulWidget {
  const FormulaScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen> {
  List<FormulaModel>? _list;
  List<MaterialModel> _listMaterial = [];
  bool _isLoading = true;
  FormulaModel? _selectedItem;

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
    await FormulaApi().list(
      idProduct: widget.product.idProduct,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _list = data;
        });
        _getListItem();
      },
    );
  }

  void _getListItem() async {
    await MaterialApi().list(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) _listMaterial = data;
          _selectedItem = null;
          _isLoading = false;

          _listMaterial.insert(
            0,
            const MaterialModel(
              no: "-1",
              name: "== Select Material ==",
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
    //                     child: FormNewFormula(
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
            child: FormNewFormula(
              productId: widget.product.idProduct,
              listMaterial: _listMaterial,
              onSubmitted: _submitNewItem,
            ),
          ),
        );
      },
    );
    // }
  }

  void _submitNewItem(
    String productId,
    String code,
    String name,
    String target,
    String fine,
    String time,
    int coarse,
    int order,
  ) async {
    setState(() {
      _isLoading = true;
    });
    await FormulaApi().create(
      productId: productId,
      code: code,
      name: name,
      target: target,
      fine: fine,
      time: time,
      coarse: coarse,
      order: order,
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
    //                     padding: const EdgeInsets.all(12),
    //                     child: FormNewFormula.edit(
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
            child: FormNewFormula.edit(
              item: _selectedItem,
              productId: widget.product.idProduct,
              listMaterial: _listMaterial,
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

  void _submitEditItem(
    String productId,
    String code,
    String name,
    String target,
    String fine,
    String time,
    int coarse,
    int order,
  ) async {
    setState(() {
      _isLoading = true;
    });
    await FormulaApi().edit(
      id: _selectedItem!.idFormula,
      productId: productId,
      code: code,
      name: name,
      target: target,
      fine: fine,
      time: time,
      coarse: coarse,
      order: order,
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
          'Are you sure you want to delete ${_selectedItem!.nameMaterial} with code ${_selectedItem!.kodeMaterial}?',
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
    await FormulaApi().delete(
      id: _selectedItem!.idFormula,
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
          crossAxisAlignment: Platform.isIOS
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.nameProduct,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.product.kodeProduct,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
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
                      Icons.receipt_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'List Formula',
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
                                // onTap: () {},
                                isSelected:
                                    (_selectedItem != null &&
                                        _selectedItem!.idFormula ==
                                            item.idFormula)
                                    ? true
                                    : false,
                                badge: item.kodeMaterial,
                                title: item.nameMaterial,
                                description:
                                    '${item.targetFormula} kg in ${item.timeTarget} second (Fine ${item.fineFormula} kg)',
                                customTrailingIcon: PopupMenuButton<FormulaModel>(
                                  icon: const Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (ctx) {
                                    return [
                                      // PopupMenuItem<FormulaModel>(
                                      //   onTap: () async {
                                      //     await Future.delayed(const Duration(
                                      //         milliseconds: 250));
                                      //     setState(() {
                                      //       _selectedItem = null;
                                      //     });
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
                                      PopupMenuItem<FormulaModel>(
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
                                      PopupMenuItem<FormulaModel>(
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
