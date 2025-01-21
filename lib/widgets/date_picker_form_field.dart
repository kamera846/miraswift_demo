import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerFormField extends StatefulWidget {
  const DatePickerFormField(
      {super.key, required this.value, this.onChanged, this.validator});

  final String value;
  final Function(String dateString)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      if (widget.onChanged != null) {
        String dateString = "${pickedDate.toLocal()}".split(' ')[0];
        _dateController.text = dateString;
        widget.onChanged!(dateString);
      }
    }
  }

  @override
  void initState() {
    _dateController.text = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: 'Click date icon to select ->',
          hintStyle: const TextStyle(color: Colors.black87),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.blue.shade900,
              width: 2,
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              _selectDate(context);
            },
            child: const Icon(
              CupertinoIcons.calendar,
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
