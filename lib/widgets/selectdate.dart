import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testnav/widgets/pallet.dart';

class CustomDateSelection extends StatefulWidget {
  const CustomDateSelection({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
    this.hint = 'YYYY-MM-DD',
    this.backgroundColor = textFieldBGColor,
    this.focusedBorderColor = primaryColor,
    this.isIconed = false,
    this.icon,
  });

  final String label; // Label for the date picker
  final DateTime? selectedDate; // Initially selected date
  final void Function(DateTime)
      onDateSelected; // Callback when a date is selected
  final String hint; // Hint text
  final Color backgroundColor; // Background color of the field
  final Color focusedBorderColor; // Border color when focused
  final bool isIconed; // Determines if an icon is added
  final Icon? icon; // Icon to display (if `isIconed` is true)

  @override
  _CustomDateSelectionState createState() => _CustomDateSelectionState();
}

class _CustomDateSelectionState extends State<CustomDateSelection> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(20),
        child: TextField(
          readOnly: true,
          // Disable text input
          controller: TextEditingController(
            text: _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : '', // Format and display the selected date
          ),
          onTap: () async {
            // Show date picker dialog
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
              widget.onDateSelected(pickedDate);
            }
          },
          style: TextStyle(
            color: primaryColor,
            fontSize: 20, // Match hint font size to input text
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 20, // Match hint font size to input text
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: widget.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            prefixIcon: widget.isIconed ? widget.icon : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
          ),
        ),
      ),
    );
  }
}
