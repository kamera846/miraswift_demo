import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/screens/batch_detail_screen.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
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
  bool _searchFocus = false;
  List<BatchModel>? _batchs;
  bool isLoading = true;
  bool isFilterShowed = false;
  bool isScrolled = false;

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
                  color: Colors.white,
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
                        color: Colors.white,
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
                              Text(
                                'Filter by product',
                                style: Theme.of(context).textTheme.titleSmall,
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
