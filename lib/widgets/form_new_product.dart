import 'package:flutter/material.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/utils/snackbar.dart';

class FormNewProduct extends StatefulWidget {
  const FormNewProduct({
    super.key,
    this.onSubmitting,
    this.onSubmitted,
  });

  final void Function(bool state)? onSubmitting;
  final void Function()? onSubmitted;

  @override
  FormNewProductState createState() => FormNewProductState();
}

class FormNewProductState extends State<FormNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _codeInput = '';
  String _nameInput = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _newProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      // print('Submit state: true');
      // widget.onSubmitting(true);
      // await Future.delayed(const Duration(seconds: 5));
      // setState(() {
      //   _isLoading = false;
      // });
      // print('Submit state: false');
      // widget.onSubmitting(false);
      // return;
      await ProductApi().create(
        productCode: _codeInput,
        productName: _nameInput,
        onSuccess: (msg) {
          if (widget.onSubmitted != null) widget.onSubmitted!();
          showSnackBar(context, msg);
        },
        onError: (msg) => showSnackBar(context, msg),
        onCompleted: () {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop(true);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'New Product',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !_isLoading,
                controller: _codeController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Code',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'PRD001',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  _codeInput = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                enabled: !_isLoading,
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Thinbed',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nameInput = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _newProduct,
                child: Text(_isLoading ? 'Submitting..' : 'Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
