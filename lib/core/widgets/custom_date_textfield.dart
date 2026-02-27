import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTextfield extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelect;
  final TextEditingController? controller;
  const CustomDateTextfield({
    super.key,
    required this.label,
    required this.onDateSelect,
    this.controller,
  });

  @override
  State<CustomDateTextfield> createState() => _CustomDateTextfieldState();
}

class _CustomDateTextfieldState extends State<CustomDateTextfield> {
  late TextEditingController _internalController;
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('vi', 'VN'),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

      setState(() {
        _effectiveController.text = formattedDate;
      });

      widget.onDateSelect(pickedDate);
    }
  }

  @override
  void dispose() {
    _effectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _effectiveController,
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: 'Chọn ngày',
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
