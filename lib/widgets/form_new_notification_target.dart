import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/user_model.dart';

class FormNewNotificationTarget extends StatefulWidget {
  const FormNewNotificationTarget({
    super.key,
    required this.onSubmitted,
  })  : isEdit = false,
        item = null;
  const FormNewNotificationTarget.edit({
    super.key,
    required this.item,
    required this.onSubmitted,
  }) : isEdit = true;

  final bool isEdit;
  final UserModel? item;
  final void Function(String name, String phone, String status) onSubmitted;

  @override
  FormNewNotificationTargetState createState() =>
      FormNewNotificationTargetState();
}

class FormNewNotificationTargetState extends State<FormNewNotificationTarget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _phoneInput = '';
  String _nameInput = '';

  bool _status = false;

  @override
  void initState() {
    if (widget.isEdit) _setupItem();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _setupItem() {
    _phoneInput = widget.item!.phoneUser;
    _nameInput = widget.item!.nameUser;
    _phoneController.text = widget.item!.phoneUser;
    _nameController.text = widget.item!.nameUser;
    _status = widget.item!.isActive == "1" ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.isEdit
              ? 'Edit Notification Target'
              : 'New Notification Target',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: Theme.of(context).textTheme.bodySmall,
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
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _phoneController,
                style: Theme.of(context).textTheme.bodySmall,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  hintText: 'ex: 6281XXXXXX',
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  final RegExp _phoneRegExp =
                      RegExp(r'^\+?[1-9]\d{1,14}$'); // E.164 format
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (!_phoneRegExp.hasMatch(value)) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneInput = value ?? '';
                },
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Toggle Status (${_status ? 'active' : 'disabled'})'),
                  Switch(
                    value: _status,
                    activeColor: Colors.green.shade900.withAlpha(150),
                    activeTrackColor: Colors.green.shade900.withAlpha(75),
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    String statusInput = _status ? "1" : "0";
                    widget.onSubmitted(_nameInput, _phoneInput, statusInput);
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
    );
  }
}
