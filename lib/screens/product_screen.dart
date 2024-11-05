import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel>? _list;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() async {
    setState(() {
      isLoading = true;
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
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting Recipe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              child: (!isLoading && _list != null && _list!.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _list!.length,
                      itemBuilder: (ctx, index) {
                        final item = _list![index];
                        final isLastIndex = (index == (_list!.length - 1));
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
                      })
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(isLoading
                            ? 'Loading..'
                            : !isLoading && (_list == null || _list!.isEmpty)
                                ? 'Data is empty.'
                                : ''),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
