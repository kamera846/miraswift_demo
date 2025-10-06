import 'package:flutter/material.dart';
import 'package:miraswiftdemo/models/formula_model.dart';
import 'package:miraswiftdemo/models/material_model.dart';

class FormNewFormula extends StatefulWidget {
  const FormNewFormula({
    super.key,
    required this.productId,
    required this.listMaterial,
    required this.onSubmitted,
  }) : isEdit = false,
       item = null;
  const FormNewFormula.edit({
    super.key,
    required this.item,
    required this.productId,
    required this.listMaterial,
    required this.onSubmitted,
  }) : isEdit = true;

  final bool isEdit;
  final String productId;
  final FormulaModel? item;
  final List<MaterialModel> listMaterial;
  final void Function(
    String productId,
    String code,
    String name,
    String target,
    String fine,
    String time,
    int coarse,
    int order,
  )
  onSubmitted;

  @override
  FormNewFormulaState createState() => FormNewFormulaState();
}

class FormNewFormulaState extends State<FormNewFormula> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _targetFormulaController =
      TextEditingController();
  final TextEditingController _fineFormulaController = TextEditingController();
  final TextEditingController _timeTargetController = TextEditingController();
  final TextEditingController _coarseController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();

  String _targetFormulaInput = '';
  String _fineFormulaInput = '';
  String _timeTargetInput = '';
  String _coarseInput = '';
  String _orderInput = '';

  MaterialModel? _selectedMaterial;

  @override
  void initState() {
    _selectedMaterial = widget.listMaterial.first;
    if (widget.isEdit) _setupItem();
    super.initState();
  }

  @override
  void dispose() {
    _targetFormulaController.dispose();
    _fineFormulaController.dispose();
    _timeTargetController.dispose();
    _coarseController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _setupItem() {
    _targetFormulaInput = widget.item!.targetFormula;
    _fineFormulaInput = widget.item!.fineFormula;
    _timeTargetInput = widget.item!.timeTarget;
    _coarseInput = widget.item!.coarseFormula;
    _orderInput = widget.item!.orderFormula;
    _targetFormulaController.text = widget.item!.targetFormula;
    _fineFormulaController.text = widget.item!.fineFormula;
    _timeTargetController.text = widget.item!.timeTarget;
    _coarseController.text = widget.item!.coarseFormula;
    _orderController.text = widget.item!.orderFormula;
    _selectedMaterial = widget.listMaterial.firstWhere(
      (item) => item.no == widget.item!.kodeMaterial,
      orElse: () => widget.listMaterial.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isEdit ? 'Edit Formula' : 'New Formula',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<MaterialModel>(
                  initialValue: _selectedMaterial,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: widget.listMaterial
                      .map<DropdownMenuItem<MaterialModel>>((
                        MaterialModel value,
                      ) {
                        return DropdownMenuItem<MaterialModel>(
                          value: value,
                          child: Text(
                            value.id != -1
                                ? '${value.name} [${value.no.toString()}]'
                                : value.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      })
                      .toList(),
                  onChanged: (MaterialModel? value) {
                    setState(() {
                      _selectedMaterial = value!;
                    });
                  },
                  validator: (value) {
                    if (value!.id == -1) {
                      return 'Please select the material';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _selectedMaterial = value!;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _targetFormulaController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Target (kg)',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          hintText: '100.0',
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
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
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: TextFormField(
                        controller: _fineFormulaController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Fine (kg)',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          hintText: '5.0',
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
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
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timeTargetController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Time (second)',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          hintText: '60',
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
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
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: TextFormField(
                        controller: _coarseController,
                        style: Theme.of(context).textTheme.bodySmall,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Coarse (kg)',
                          hintText: '5.0',
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
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
                          _coarseInput = value ?? '';
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _orderController,
                  style: Theme.of(context).textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Urutan Formula',
                    hintText: '1',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some number';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Nilai harus lebih dari 0';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _orderInput = value ?? '';
                  },
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();

                      widget.onSubmitted(
                        widget.productId,
                        _selectedMaterial!.no,
                        _selectedMaterial!.name,
                        _targetFormulaInput,
                        _fineFormulaInput,
                        _timeTargetInput,
                        int.parse(_coarseInput),
                        int.parse(_orderInput),
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
