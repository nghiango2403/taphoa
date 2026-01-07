import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTextfield extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelect;
  const CustomDateTextfield({
    super.key,
    required this.label,
    required this.onDateSelect,
  });

  @override
  State<CustomDateTextfield> createState() => _CustomDateTextfieldState();
}

class _CustomDateTextfieldState extends State<CustomDateTextfield> {
  final TextEditingController _controller = TextEditingController();
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
        _controller.text = formattedDate;
      });

      widget.onDateSelect(pickedDate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
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
