import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/formula_model.dart';

class FormNewFormula extends StatefulWidget {
  const FormNewFormula({
    super.key,
    required this.productId,
    required this.onSubmitted,
  })  : isEdit = false,
        item = null;
  const FormNewFormula.edit({
    super.key,
    required this.item,
    required this.productId,
    required this.onSubmitted,
  }) : isEdit = true;

  final bool isEdit;
  final String productId;
  final FormulaModel? item;
  final void Function(
    String productId,
    String code,
    String target,
    String fine,
    String time,
  ) onSubmitted;

  @override
  FormNewFormulaState createState() => FormNewFormulaState();
}

class FormNewFormulaState extends State<FormNewFormula> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _targetFormulaController =
      TextEditingController();
  final TextEditingController _fineFormulaController = TextEditingController();
  final TextEditingController _codeMaterialController = TextEditingController();
  final TextEditingController _timeTargetController = TextEditingController();

  String _targetFormulaInput = '';
  String _fineFormulaInput = '';
  String _codeMaterialInput = '';
  String _timeTargetInput = '';

  @override
  void initState() {
    if (widget.isEdit) _setupItem();
    super.initState();
  }

  @override
  void dispose() {
    _targetFormulaController.dispose();
    _fineFormulaController.dispose();
    _codeMaterialController.dispose();
    _timeTargetController.dispose();
    super.dispose();
  }

  void _setupItem() {
    _targetFormulaInput = widget.item!.targetFormula;
    _fineFormulaInput = widget.item!.fineFormula;
    _codeMaterialInput = widget.item!.kodeMaterial;
    _timeTargetInput = widget.item!.timeTarget;
    _targetFormulaController.text = widget.item!.targetFormula;
    _fineFormulaController.text = widget.item!.fineFormula;
    _codeMaterialController.text = widget.item!.kodeMaterial;
    _timeTargetController.text = widget.item!.timeTarget;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.isEdit ? 'Edit Formula' : 'New Formula',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeMaterialController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Code Material',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: '1001',
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
                  _codeMaterialInput = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _targetFormulaController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Target (kg)',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: '100.0',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _targetFormulaInput = value ?? '';
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _fineFormulaController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Fine (kg)',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: '5.0',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _fineFormulaInput = value ?? '';
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _timeTargetController,
                style: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Time (second)',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: '60',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _timeTargetInput = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    widget.onSubmitted(
                      widget.productId,
                      _codeMaterialInput,
                      _targetFormulaInput,
                      _fineFormulaInput,
                      _timeTargetInput,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit Now'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}
