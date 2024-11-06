import 'package:flutter/material.dart';

class FormNewProduct extends StatefulWidget {
  const FormNewProduct({
    super.key,
    required this.onSubmitted,
  });

  final void Function(String code, String name) onSubmitted;

  @override
  FormNewProductState createState() => FormNewProductState();
}

class FormNewProductState extends State<FormNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _codeInput = '';
  String _nameInput = '';

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
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
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    widget.onSubmitted(_codeInput, _nameInput);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit Now'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
