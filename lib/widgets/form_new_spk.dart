import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/product_model.dart';
import 'package:miraswiftdemo/models/spk_model.dart';
import 'package:miraswiftdemo/widgets/date_picker_form_field.dart';

class FormNewSpk extends StatefulWidget {
  const FormNewSpk({
    super.key,
    required this.onSubmitted,
    required this.listProduct,
  }) : isEdit = false,
       item = null;
  const FormNewSpk.edit({
    super.key,
    required this.item,
    required this.onSubmitted,
    required this.listProduct,
  }) : isEdit = true;

  final bool isEdit;
  final SpkModel? item;
  final List<ProductModel> listProduct;
  final void Function(
    String idProduct,
    String jmlBatch,
    String dateSpk,
    String descSpk,
  )
  onSubmitted;

  @override
  FormNewSpkState createState() => FormNewSpkState();
}

class FormNewSpkState extends State<FormNewSpk> {
  final _formKey = GlobalKey<FormState>();
  ProductModel? _selectedProduct;
  String _selectedDate = '';

  final TextEditingController _jmlBatchController = TextEditingController();
  final TextEditingController _descSpkController = TextEditingController();

  @override
  void initState() {
    _selectedProduct = widget.listProduct.first;
    if (widget.isEdit) {
      _selectedProduct = widget.listProduct.firstWhere(
        (item) => item.idProduct == widget.item!.idProduct,
        orElse: () => widget.listProduct.first,
      );
      _selectedDate = widget.item!.dateSpk;
      _jmlBatchController.text = widget.item!.jmlBatch;
      _descSpkController.text = widget.item!.descSpk;
    }
    super.initState();
  }

  @override
  void dispose() {
    _jmlBatchController.dispose();
    _descSpkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isEdit ? 'Edit SPK' : 'New SPK',
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
                  items: widget.listProduct.map<DropdownMenuItem<ProductModel>>((
                    ProductModel value,
                  ) {
                    return DropdownMenuItem<ProductModel>(
                      value: value,
                      child: Text(
                        value.idProduct != '-1'
                            ? '${value.nameProduct} [${value.kodeProduct.toString()}]'
                            : value.nameProduct,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                  onChanged: (ProductModel? value) {
                    setState(() {
                      _selectedProduct = value!;
                    });
                  },
                  validator: (value) {
                    if (value!.idProduct == '-1') {
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
                TextFormField(
                  controller: _descSpkController,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    hintText: 'e.g XPANDER GROUT',
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  // onSaved: (value) {
                  //   _targetFormulaInput = value ?? '';
                  // },
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DatePickerFormField(
                        value: _selectedDate,
                        onChanged: (dateString) => setState(() {
                          _selectedDate = dateString;
                        }),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _jmlBatchController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Total batch',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          hintText: 'e.g 15',
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter total batch';
                          }
                          return null;
                        },
                        // onSaved: (value) {
                        //   _fineFormulaInput = value ?? '';
                        // },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();

                      widget.onSubmitted(
                        _selectedProduct!.idProduct,
                        _jmlBatchController.text,
                        _selectedDate,
                        _descSpkController.text,
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
