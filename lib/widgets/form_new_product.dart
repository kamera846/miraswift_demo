import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/product_model.dart';

class FormNewProduct extends StatefulWidget {
  const FormNewProduct({
    super.key,
    required this.onSubmitted,
    required this.listProduct,
  }) : isEdit = false,
       item = null;
  const FormNewProduct.edit({
    super.key,
    required this.item,
    required this.onSubmitted,
    required this.listProduct,
  }) : isEdit = true;

  final bool isEdit;
  final ProductModel? item;
  final List<ProductModel> listProduct;
  final void Function(String code, String name) onSubmitted;

  @override
  FormNewProductState createState() => FormNewProductState();
}

class FormNewProductState extends State<FormNewProduct> {
  final _formKey = GlobalKey<FormState>();

  ProductModel? _selectedProduct;

  @override
  void initState() {
    _selectedProduct = widget.listProduct.first;
    if (widget.isEdit) {
      _selectedProduct = widget.listProduct.firstWhere(
        (item) => item.no == widget.item!.kodeProduct,
        orElse: () => widget.listProduct.first,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isEdit ? 'Edit Product' : 'New Product',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<ProductModel>(
                  initialValue: _selectedProduct,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: widget.listProduct.map<DropdownMenuItem<ProductModel>>(
                    (ProductModel value) {
                      return DropdownMenuItem<ProductModel>(
                        value: value,
                        child: Text(
                          value.id != -1
                              ? '${value.name} [${value.no.toString()}]'
                              : value.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (ProductModel? value) {
                    setState(() {
                      _selectedProduct = value!;
                    });
                  },
                  validator: (value) {
                    if (value!.id == -1) {
                      return 'Please select the product';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _selectedProduct = value!;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();

                      widget.onSubmitted(
                        _selectedProduct!.no,
                        _selectedProduct!.name,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit Now'),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
