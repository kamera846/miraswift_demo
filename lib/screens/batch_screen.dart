import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/screens/batch_detail_screen.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/fullwidth_button.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class BatchScreen extends StatefulWidget {
  const BatchScreen({super.key});

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _searchFocus = false;
  List<BatchModel>? _batchs;
  bool isLoading = true;
  bool isScrolled = false;
  bool isFilterShowed = false;
  String _filteredDate = '';
  ProductModel? _filteredProduct;
  ProductModel? _selectedProduct;
  List<ProductModel>? _listProduct;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () {
        setState(() {
          _searchFocus = _focusNode.hasFocus;
        });
      },
    );
    _getBatchs();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _getBatchs() async {
    setState(() {
      isLoading = true;
    });
    await BatchApiService().batchs(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _batchs = data;
        });
        _getProduct();
      },
    );
  }

  void _getProduct() async {
    await ProductApi().list(
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          _listProduct = data;
          isLoading = false;
        });
      },
    );
  }

  void _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels > 10) {
        // Jika sudah scroll lebih dari 10
        setState(() {
          isScrolled = true;
        });
      } else {
        setState(() {
          isScrolled = false;
        });
      }
    }
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
        _dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format to yyyy-mm-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Batch', style: Theme.of(context).textTheme.titleMedium),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                if (isScrolled || isFilterShowed)
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Form(
                        key: _formKey,
                        child: Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            style: Theme.of(context).textTheme.bodySmall,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) => _getBatchs,
                            decoration: InputDecoration(
                              hintText: 'Search batch number..',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  _getBatchs();
                                },
                                child: Icon(
                                  CupertinoIcons.search,
                                  color:
                                      _searchFocus ? Colors.blue : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color:
                                    isFilterShowed ? Colors.blue : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isFilterShowed = !isFilterShowed;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  CupertinoIcons.line_horizontal_3_decrease,
                                  color: isFilterShowed
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: !isFilterShowed
                      ? Row(
                          children: [
                            if (_filteredDate.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 8, right: 8),
                                padding: const EdgeInsets.only(left: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.blue,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _filteredDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _filteredDate = '';
                                            _dateController.text = '';
                                          });
                                          _getBatchs();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 4, right: 12),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (_filteredProduct != null)
                              Container(
                                margin: const EdgeInsets.only(top: 8, right: 8),
                                padding: const EdgeInsets.only(left: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.blue,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _filteredProduct!.nameProduct,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedProduct = null;
                                            _filteredProduct = null;
                                          });
                                          _getBatchs();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 4, right: 12),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isFilterShowed
                      ? Padding(
                          key: const ValueKey('filters'),
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filter by date',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: TextFormField(
                                    controller: _dateController,
                                    readOnly: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.blue,
                                        ),
                                    decoration: InputDecoration(
                                      hintText: 'click date icon to select ->',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.grey,
                                          ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12),
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
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          _selectDate(context);
                                        },
                                        child: const Icon(
                                          CupertinoIcons.calendar,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Filter by product',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              if (!isLoading &&
                                  _listProduct != null &&
                                  _listProduct!.isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _listProduct!.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 6, right: 6),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _selectedProduct = item;
                                            });
                                          },
                                          label: Text(
                                            item.nameProduct,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: _selectedProduct
                                                                ?.idProduct ==
                                                            item.idProduct
                                                        ? Colors.blue
                                                        : Colors.black87),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color:
                                                  _selectedProduct?.idProduct ==
                                                          item.idProduct
                                                      ? Colors.blue
                                                      : Colors.black87,
                                            ),
                                            iconColor:
                                                _selectedProduct?.idProduct ==
                                                        item.idProduct
                                                    ? Colors.blue
                                                    : Colors.black87,
                                            surfaceTintColor:
                                                _selectedProduct?.idProduct ==
                                                        item.idProduct
                                                    ? Colors.blue
                                                    : Colors.black87,
                                          ),
                                          icon: const Icon(
                                            CupertinoIcons
                                                .checkmark_alt_circle_fill,
                                            size: 18,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(isLoading
                                      ? 'Loading..'
                                      : !isLoading &&
                                              (_batchs == null ||
                                                  _batchs!.isEmpty)
                                          ? 'No products created.'
                                          : ''),
                                ),
                              const SizedBox(height: 6),
                              FullwidthButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    isFilterShowed = !isFilterShowed;
                                    _filteredDate = _dateController.text;
                                    _filteredProduct = _selectedProduct;
                                  });
                                  _getBatchs();
                                },
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox
                          .shrink(), // An empty widget when the filter is hidden
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _onScroll(notification); // Menangani scroll
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 12, right: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.miscellaneous_services_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('List Batch',
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withAlpha(75)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: (!isLoading &&
                              _batchs != null &&
                              _batchs!.isNotEmpty)
                          ? Column(
                              children: _batchs!.map((item) {
                                final isLastIndex =
                                    (index == (_batchs!.length - 1));
                                index++;
                                return Column(
                                  children: [
                                    ListTileItem(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                BatchDetailScreen(batch: item),
                                          ),
                                        );
                                      },
                                      badge: 'Thinbed',
                                      customTrailingIcon: IconButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  BatchDetailScreen(
                                                      batch: item),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.chevron_right_rounded,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: item.noBatch,
                                      description: formattedDate(
                                          dateStr: item.dateEquipment),
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
                                child: Text(isLoading
                                    ? 'Loading..'
                                    : !isLoading &&
                                            (_batchs == null ||
                                                _batchs!.isEmpty)
                                        ? 'Data is empty.'
                                        : ''),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
