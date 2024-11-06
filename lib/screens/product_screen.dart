import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/form_new_product.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel>? _list;
  bool _isLoading = true;
  // bool _isSubmitting = false;

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
          _isLoading = false;
        });
      },
    );
  }

  void _newProduct() {
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
              onSubmitted: _submitNewProduct,
            ),
          ),
        );
      },
    );
  }

  void _submitNewProduct(String code, String name) async {
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

  @override
  Widget build(BuildContext context) {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    var index = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting Recipe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _newProduct,
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
                    Icons.token_rounded,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List Product',
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
                              badge: item.kodeProduct,
                              title: item.nameProduct,
                              description: item.createdAt,
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
