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
  List<BatchModel>? _batchFastest;
  bool isLoading = true;
  bool isLoadMore = false;
  bool isBatchFastestLoading = true;
  bool isShowedFastestBatch = false;
  bool isScrolled = false;
  bool isFilterShowed = false;
  String _filteredDate = '';
  ProductModel? _filteredProduct;
  ProductModel? _selectedProduct;
  List<ProductModel>? _listProduct;
  String _emptyMessage = "Data is empty.";

  int totalItems = 0;
  int _itemCount = 0;
  final int _increment = 15;

  final ScrollController _scrollController = ScrollController();

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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreItems();
      }
    });
    _getBatchs();
  }

  void _loadMoreItems() {
    if (_itemCount < totalItems && !isLoadMore) {
      setState(() {
        isLoadMore = true;
      });
      Future.delayed(
        const Duration(seconds: 1),
        () {
          setState(() {
            isLoadMore = false;
            _itemCount = (_itemCount + _increment).clamp(0, totalItems);
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _getBatchs({bool? isSilentRefresh = false}) async {
    setState(() {
      isShowedFastestBatch = false;
      if (isSilentRefresh != true) {
        isLoading = true;
        totalItems = 0;
        _itemCount = 0;
      }
    });

    String? batchNumber;
    String? date;
    String? product;

    if (_searchController.text.isNotEmpty) {
      batchNumber = _searchController.text;
    } else {
      batchNumber = null;
    }

    if (_filteredDate.isNotEmpty) {
      date = _filteredDate;
    } else {
      date = null;
    }

    if (_filteredProduct != null) {
      product = _filteredProduct!.kodeProduct;
      _getFastestBatch(_filteredProduct!.idProduct,
          isSilentRefresh: isSilentRefresh);
    } else {
      product = null;
    }

    await BatchApiService().batchs(
      batch: batchNumber,
      date: date,
      product: product,
      onError: (msg) {
        if (mounted) {
          showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        final dataLength = data?.length ?? 0;
        setState(() {
          _batchs = data;
          totalItems = dataLength;
          if (dataLength > 15) {
            _itemCount = 15;
          } else {
            _itemCount = dataLength;
          }
          if (_batchs == null || _batchs!.isEmpty) {
            if (batchNumber != null || date != null || product != null) {
              _emptyMessage = 'Data is empty. Try to change your filter.';
            }
          }
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
          if (data != null) {
            _listProduct = data.reversed.toList();
          } else {
            _listProduct = data;
          }
          isLoading = false;
        });
      },
    );
  }

  void _getFastestBatch(String idProduct,
      {bool? isSilentRefresh = false}) async {
    setState(() {
      if (isSilentRefresh != true) {
        isBatchFastestLoading = true;
      }
      isShowedFastestBatch = true;
    });
    await BatchApiService().batchFastest(
      idProduct: idProduct,
      onError: (msg) {
        if (mounted) {
          if (isSilentRefresh != true) {
            showSnackBar(context, msg);
          }
        }
      },
      onCompleted: (data) {
        setState(() {
          _batchFastest = data;
          isBatchFastestLoading = false;
        });
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
        _dateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format to yyyy-mm-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batch', style: Theme.of(context).textTheme.titleMedium),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          _sectionFilter(context),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (isShowedFastestBatch == true) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 12, right: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.leaderboard_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                              'Best Batch on ${_filteredProduct?.nameProduct} (${_batchFastest?.length ?? 0})',
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _sectionFastest(context),
                  )
                ],
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, right: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_circle,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text('List Batch (${_batchs?.length ?? 0})',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _sectionItems(context),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _sectionFastest(BuildContext context) {
    int itemCount = _batchFastest?.length ?? 0;

    if (itemCount > 3) itemCount = 3;

    return (!isBatchFastestLoading &&
            _batchFastest != null &&
            _batchFastest!.isNotEmpty)
        ? Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: itemCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _batchFastest![index];
                final isLastIndex = (index == (_batchFastest!.length - 1));
                Badge leadingIcon = const Badge(
                  isLabelVisible: false,
                  child: Icon(
                    Icons.leaderboard_rounded,
                    color: Colors.grey,
                    size: 40,
                  ),
                );

                if (index == 0) {
                  leadingIcon = const Badge(
                    alignment: Alignment(-0.3, -0.45),
                    backgroundColor: Colors.transparent,
                    label: Text('1'),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                } else if (index == 1) {
                  leadingIcon = const Badge(
                    alignment: Alignment(-0.35, -0.35),
                    backgroundColor: Colors.white,
                    label: Text(
                      '2',
                      style: TextStyle(color: Colors.brown),
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.brown,
                      size: 40,
                    ),
                  );
                } else if (index == 2) {
                  leadingIcon = const Badge(
                    alignment: Alignment(-0.33, -0.13),
                    backgroundColor: Colors.transparent,
                    label: Text(
                      '3',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      Icons.star_rate_rounded,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
                  );
                }

                return Column(
                  children: [
                    ListTileItem(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    BatchDetailScreen(batch: item),
                              ),
                            )
                            .then((value) => _getBatchs(isSilentRefresh: true));
                      },
                      title: item.noBatch,
                      description: 'Total time ${item.totalEquipmentTime}',
                      badge: _filteredProduct?.nameProduct ?? '',
                      customLeadingIcon: leadingIcon,
                      customTrailingIcon: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      BatchDetailScreen(batch: item),
                                ),
                              )
                              .then(
                                  (value) => _getBatchs(isSilentRefresh: true));
                        },
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    if (!isLastIndex)
                      Divider(
                        height: 0,
                        color: Colors.grey.shade300,
                      ),
                  ],
                );
              },
            ),
          )
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  isBatchFastestLoading
                      ? 'Loading..'
                      : !isBatchFastestLoading &&
                              (_batchFastest == null || _batchFastest!.isEmpty)
                          ? 'Data is empty.'
                          : '',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }

  Container _sectionItems(BuildContext context) {
    return (!isLoading && _batchs != null && _batchs!.isNotEmpty)
        ? Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _itemCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _batchs![index];
                final isLastIndex = (index == (_batchs!.length - 1));
                return Column(
                  children: [
                    ListTileItem(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    BatchDetailScreen(batch: item),
                              ),
                            )
                            .then((value) => _getBatchs(isSilentRefresh: true));
                      },
                      title: item.noBatch,
                      description:
                          'SPK ${item.spk?.descSpk} \u2022 ${formattedDate(dateStr: item.dateEquipment)}',
                      badge: item.product?.nameProduct,
                      customTrailingIcon: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      BatchDetailScreen(batch: item),
                                ),
                              )
                              .then(
                                  (value) => _getBatchs(isSilentRefresh: true));
                        },
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    if (!isLastIndex)
                      Divider(
                        height: 0,
                        color: Colors.grey.shade300,
                      ),
                    if ((index + 1) == _itemCount && !isLastIndex)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Loading...'),
                      ),
                  ],
                );
              },
            ),
          )
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  isLoading
                      ? 'Loading..'
                      : !isLoading && (_batchs == null || _batchs!.isEmpty)
                          ? _emptyMessage
                          : '',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }

  Container _sectionFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 12, bottom: 12, left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
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
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) => _getBatchs(),
                      decoration: InputDecoration(
                        hintText: 'Search batch number..',
                        hintStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Colors.grey,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _getBatchs();
                          },
                          child: Icon(
                            CupertinoIcons.search,
                            color: _searchFocus ? Colors.blue : Colors.black,
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
                          color: isFilterShowed ? Colors.blue : Colors.grey,
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
                            isFilterShowed
                                ? CupertinoIcons.xmark
                                : CupertinoIcons.line_horizontal_3_decrease,
                            color: isFilterShowed ? Colors.blue : Colors.black,
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
                            color: Colors.blue.withAlpha(200),
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
                            color: Colors.blue.withAlpha(200),
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
                            padding: const EdgeInsets.symmetric(vertical: 6),
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
                                hintText: 'Click date icon to select',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                contentPadding: const EdgeInsets.symmetric(
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
                                  padding:
                                      const EdgeInsets.only(top: 6, right: 6),
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
                                                  ? Colors.blue.withAlpha(200)
                                                  : Colors.black87),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: _selectedProduct?.idProduct ==
                                                item.idProduct
                                            ? Colors.blue.withAlpha(200)
                                            : Colors.black54,
                                      ),
                                      iconColor: _selectedProduct?.idProduct ==
                                              item.idProduct
                                          ? Colors.blue.withAlpha(200)
                                          : Colors.black54,
                                      surfaceTintColor:
                                          _selectedProduct?.idProduct ==
                                                  item.idProduct
                                              ? Colors.blue.withAlpha(200)
                                              : Colors.black54,
                                    ),
                                    icon: const Icon(
                                      CupertinoIcons.checkmark_alt_circle_fill,
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
                            child: Text(
                              isLoading
                                  ? 'Loading..'
                                  : !isLoading &&
                                          (_batchs == null || _batchs!.isEmpty)
                                      ? _emptyMessage
                                      : '',
                              textAlign: TextAlign.center,
                            ),
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
                          backgroundColor: Colors.blue.withAlpha(200),
                          child: const Text(
                            "Apply Filter",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
