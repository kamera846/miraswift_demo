import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/product_model.dart';
import 'package:miraswiftdemo/models/spk_model.dart';
import 'package:miraswiftdemo/services/product_api.dart';
import 'package:miraswiftdemo/services/spk_api.dart';
import 'package:miraswiftdemo/utils/formatted_date.dart';
import 'package:miraswiftdemo/utils/snackbar.dart';
import 'package:miraswiftdemo/widgets/form_new_spk.dart';
import 'package:miraswiftdemo/widgets/list_tile_item.dart';
import 'package:miraswiftdemo/utils/platform_alert_dialog.dart';

class SpkScreen extends StatefulWidget {
  const SpkScreen({super.key});

  @override
  State<SpkScreen> createState() => _SpkScreenState();
}

class _SpkScreenState extends State<SpkScreen> {
  // List<SpkModel>? _listDate;
  // List<SpkModel>? _listPast;
  // List<SpkModel>? _listNow;
  // List<SpkModel>? _listUpcoming;
  List<SpkModel>? _listFiltered;
  List<ProductModel> _listProduct = [];
  SpkModel? _selectedItem;
  bool _isLoading = true;
  String _filterStatus = 'all';

  final TextEditingController _dateController = TextEditingController();

  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    var dateNow = DateTime.now();
    _dateController.text = "${dateNow.toLocal()}".split(' ')[0];
    _filterStatus = 'all';
    _getList();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _getList() async {
    setState(() {
      // _listDate = null;
      // _listNow = null;
      // _listUpcoming = null;
      // _listPast = null;
      _listFiltered = null;
      _isLoading = true;
    });
    // if (_dateController.text.isNotEmpty) {
    await SpkApi().listWithFilter(
      date: _dateController.text,
      status: _filterStatus,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          // _listDate = data;
          _listFiltered = data;
          _selectedItem = null;
        });
        _getListProduct();
      },
    );
    // } else {
    //   _getListNow();
    // }
  }

  // void _getListNow() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await SpkApi().listByPeriod(
  //     period: 'now',
  //     onError: (msg) {
  //       if (mounted) {
  //         showSnackBar(context, msg);
  //       }
  //     },
  //     onCompleted: (data) {
  //       setState(() {
  //         // _listNow = data;
  //       });
  //       _getListUpcoming();
  //     },
  //   );
  // }

  // void _getListUpcoming() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await SpkApi().listByPeriod(
  //     period: 'upcoming',
  //     onError: (msg) {
  //       if (mounted) {
  //         showSnackBar(context, msg);
  //       }
  //     },
  //     onCompleted: (data) {
  //       setState(() {
  //         // _listUpcoming = data;
  //       });
  //       _getListPast();
  //     },
  //   );
  // }

  // void _getListPast() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await SpkApi().listByPeriod(
  //     period: 'past',
  //     onError: (msg) {
  //       if (mounted) {
  //         showSnackBar(context, msg);
  //       }
  //     },
  //     onCompleted: (data) {
  //       setState(() {
  //         // _listPast = data;
  //       });
  //       _getListProduct();
  //     },
  //   );
  // }

  void _getListProduct() async {
    await ProductApi().list(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) _listProduct = data.reversed.toList();
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
    //                     child: FormNewSpk(
    //                         onSubmitted: _submitNewItem,
    //                         listProduct: _listProduct),
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
              onSubmitted: _submitNewItem,
              listProduct: _listProduct,
            ),
          ),
        );
      },
    );
    // }
  }

  void _submitNewItem(
    String idProduct,
    String jmlBatch,
    String dateSpk,
    String descSpk,
  ) async {
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
            child: FormNewSpk.edit(
              item: _selectedItem,
              onSubmitted: _submitEditItem,
              listProduct: _listProduct,
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
    String idProduct,
    String jmlBatch,
    String dateSpk,
    String descSpk,
  ) async {
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
        _getList();
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
        _getList();
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _filterStatus = 'all';
        _dateController.text = "${pickedDate.toLocal()}".split(
          ' ',
        )[0]; // Format to yyyy-mm-dd
      });
      _getList();
    }
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
            icon: const Icon(CupertinoIcons.add_circled_solid),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  onTap: () {
                    if (!_isLoading) {
                      FocusScope.of(context).unfocus();
                      _selectDate(context);
                    }
                  },
                  controller: _dateController,
                  readOnly: true,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.blue),
                  decoration: InputDecoration(
                    hintText: 'Click date icon to filter',
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _dateController.text.isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: InkWell(
                      onTap: () {
                        if (!_isLoading) {
                          FocusScope.of(context).unfocus();
                          _selectDate(context);
                        }
                      },
                      child: const Icon(CupertinoIcons.calendar),
                    ),
                    // suffixIcon: _dateController.text.isNotEmpty
                    //     ? InkWell(
                    //         onTap: () {
                    //           FocusScope.of(context).unfocus();
                    //           setState(() {
                    //             _dateController.clear();
                    //           });
                    //           _getList();
                    //         },
                    //         child: const Icon(
                    //           CupertinoIcons.xmark_circle_fill,
                    //         ),
                    //       )
                    //     : null,
                  ),
                ),
                // child: DatePickerFormField(
                //   value: _dateController.text,
                //   onChanged: (dateString) {
                //     setState(() {
                //       _dateController.text = dateString;
                //     });
                //     _getList();
                //   },
                // ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ['all', 'pending', 'running', 'done', 'stopped']
                      .map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: OutlinedButton(
                            onPressed: () {
                              if (!_isLoading) {
                                setState(() {
                                  _filterStatus = item;
                                });
                                _getList();
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: _filterStatus == item
                                    ? _isLoading
                                          ? Colors.blue.withAlpha(50)
                                          : Colors.blue.withAlpha(100)
                                    : _isLoading
                                    ? Colors.grey.shade200
                                    : Colors.black12,
                              ),
                              backgroundColor: _filterStatus == item
                                  ? _isLoading
                                        ? Colors.blue.withAlpha(50)
                                        : Colors.blue.withAlpha(100)
                                  : _isLoading
                                  ? Colors.grey.shade200
                                  : Colors.black12,
                              padding: const EdgeInsets.all(14),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              item.toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: _filterStatus == item
                                        ? _isLoading
                                              ? Colors.blue.shade200
                                              : Colors.blue
                                        : _isLoading
                                        ? Colors.black26
                                        : Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
              if (_isLoading)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.withAlpha(75),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Loading..', textAlign: TextAlign.center),
                )
              else if (_listFiltered == null || _listFiltered!.isEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.withAlpha(75),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Data is empty.',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ListSpk(
                  listItem: _listFiltered!,
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
                ),
              // else ...[
              // if ((_listNow == null || _listNow!.isEmpty) &&
              //     (_listPast == null || _listPast!.isEmpty) &&
              //     (_listUpcoming == null || _listUpcoming!.isEmpty) &&
              //     (_listDate == null || _listDate!.isEmpty))
              //   Container(
              //     width: double.infinity,
              //     margin: const EdgeInsets.all(12),
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       border:
              //           Border.all(width: 1, color: Colors.grey.withAlpha(75)),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: const Text(
              //       'Data is empty.',
              //       textAlign: TextAlign.center,
              //     ),
              //   )
              // else if (_dateController.text.isNotEmpty)
              //   ListSpk(
              //     title: 'Filter by date',
              //     listItem: _listDate!,
              //     selectedItem: _selectedItem,
              //     onEdit: (item) {
              //       setState(() {
              //         _selectedItem = item;
              //       });
              //       _editItem();
              //     },
              //     // onDelete: (item) {
              //     //   setState(() {
              //     //     _selectedItem = item;
              //     //   });
              //     //   _deleteItem();
              //     // },
              //   )
              // else ...[
              //   _listNow != null && _listNow!.isNotEmpty
              //       ? ListSpk(
              //           title: 'Now',
              //           listItem: _listNow!,
              //           selectedItem: _selectedItem,
              //           onEdit: (item) {
              //             setState(() {
              //               _selectedItem = item;
              //             });
              //             _editItem();
              //           },
              //           onDelete: (item) {
              //             setState(() {
              //               _selectedItem = item;
              //             });
              //             _deleteItem();
              //           },
              //         )
              //       : const SizedBox.shrink(),
              //   _listUpcoming != null && _listUpcoming!.isNotEmpty
              //       ? ListSpk(
              //           title: 'Upcoming Spk',
              //           listItem: _listUpcoming!,
              //           selectedItem: _selectedItem,
              //           onEdit: (item) {
              //             setState(() {
              //               _selectedItem = item;
              //             });
              //             _editItem();
              //           },
              //           onDelete: (item) {
              //             setState(() {
              //               _selectedItem = item;
              //             });
              //             _deleteItem();
              //           },
              //         )
              //       : const SizedBox.shrink(),
              //   _listPast != null && _listPast!.isNotEmpty
              //       ? ListSpk(
              //           title: 'Past Spk',
              //           listItem: _listPast!,
              //           selectedItem: _selectedItem,
              //           withCustomTrailing: false,
              //           onEdit: (item) {
              //             setState(() {
              //               _selectedItem = item;
              //             });
              //             _editItem();
              //           },
              //           onDelete: (item) {
              //             setState(() {
              //               _selectedItem = item;
              //             });
              //             _deleteItem();
              //           },
              //           // onReorder: (oldIndex, newIndex) {
              //           //   print('$oldIndex & $newIndex');
              //           //   if (_listPast != null) {
              //           //     setState(() {
              //           //       if (oldIndex < newIndex) {
              //           //         newIndex -= 1;
              //           //       }
              //           //       final SpkModel item =
              //           //           _listPast!.removeAt(oldIndex);
              //           //       _listPast!.insert(newIndex, item);
              //           //       showSnackBar(context,
              //           //           'Sedang mengganti urutan ${item.descSpk} dari $oldIndex ke $newIndex...');
              //           //     });
              //           //     Future.delayed(const Duration(seconds: 2), () {
              //           //       showSnackBar(
              //           //           context, 'Berhasil mengganti urutan');
              //           //       // setState(() {
              //           //       //   final SpkModel item =
              //           //       //       _listPast!.removeAt(newIndex);
              //           //       //   _listPast!.insert(oldIndex, item);
              //           //       //   showSnackBar(context, 'Gagal mengganti urutan');
              //           //       // });
              //           //     });
              //           //   }
              //           // },
              //         )
              //       : const SizedBox.shrink(),
              // ]
              // ]
            ],
          ),
        ),
      ),
    );
  }
}

class ListSpk extends StatelessWidget {
  const ListSpk({
    super.key,
    this.title,
    required this.listItem,
    this.selectedItem,
    this.withCustomTrailing = true,
    this.onEdit,
    this.onDelete,
    this.onReorder,
  });

  final String? title;
  final List<SpkModel> listItem;
  final SpkModel? selectedItem;
  final bool withCustomTrailing;
  final Function(SpkModel item)? onEdit;
  final Function(SpkModel item)? onDelete;
  final Function(int oldIndex, int newIndex)? onReorder;

  @override
  Widget build(BuildContext context) {
    var index = 0;
    return Column(
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.playlist_add_check_circle,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            // onReorder: onReorder ?? (o, n) => {},
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            children: listItem.map((item) {
              final isLastIndex = (index == (listItem.length - 1));
              index++;
              return ListTileItem(
                key: Key('$index'),
                isSelected:
                    (selectedItem != null && selectedItem!.idSpk == item.idSpk)
                    ? true
                    : false,
                badge: '${item.jmlBatch} Batch',
                title: item.descSpk,
                border: !isLastIndex
                    ? Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      )
                    : null,
                rightDescription: item.statusSpk.toUpperCase(),
                description:
                    'Jadwal untuk tanggal ${formattedDate(dateStr: item.dateSpk)}',
                customLeadingIcon: item.statusSpk == 'pending'
                    ? IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(Icons.schedule, color: Colors.grey),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.grey.withAlpha(50),
                          ),
                        ),
                      )
                    : item.statusSpk == 'running'
                    ? IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(Icons.autorenew, color: Colors.orange),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.orange.withAlpha(50),
                          ),
                        ),
                      )
                    : item.statusSpk == 'done'
                    ? IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(Icons.task_alt, color: Colors.green),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.green.withAlpha(50),
                          ),
                        ),
                      )
                    : IconButton.filledTonal(
                        onPressed: null,
                        icon: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.red.withAlpha(50),
                          ),
                        ),
                      ),
                customTrailingIcon:
                    withCustomTrailing && item.statusSpk != 'done'
                    ? PopupMenuButton<SpkModel>(
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
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.pencil_circle_fill,
                                    color: Colors.orange.withAlpha(150),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Edit'),
                                ],
                              ),
                            ),
                            // PopupMenuItem<SpkModel>(
                            //   onTap: () {
                            //     onDelete!(item);
                            //   },
                            //   child: const Row(
                            //     children: [
                            //       Icon(
                            //         CupertinoIcons.trash_circle_fill,
                            //         size: 20,
                            //       ),
                            //       SizedBox(width: 12),
                            //       Text('Delete')
                            //     ],
                            //   ),
                            // ),
                          ];
                        },
                      )
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
