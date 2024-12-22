import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testnav/widgets/pallet.dart';

class CustomDateSelection extends StatefulWidget {
  const CustomDateSelection({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
    this.hint = 'Select a date',
    this.backgroundColor = textFieldBGColor,
    this.focusedBorderColor = primaryColor,
    this.isIconed = false,
    this.icon,
  });

  final String label;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final String hint;
  final Color backgroundColor;
  final Color focusedBorderColor;
  final bool isIconed;
  final Icon? icon;

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
    return SizedBox(
      height: 50, // Adjust height for smaller size
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(20),
        // Border radius similar to CustomTextFieldV2
        child: TextField(
          style: TextStyle(
            color: Color(0xFF2c82a7),
            fontWeight: FontWeight.w500, // Adjust font weight as needed
            fontSize: 20, // Reduced font size for smaller text
          ),
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
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
              widget.onDateSelected(pickedDate);
            }
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15, // Reduced vertical padding
              horizontal: 15, // Reduced horizontal padding
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 20, // Match hint font size to input text
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            suffixIcon: widget.isIconed
                ? widget.icon
                : IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF2c82a7),
                    ),
                    onPressed: () {
                      // Open date picker on icon click
                      _selectDate(context);
                    },
                  ),
            fillColor: widget.backgroundColor,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(
                  20), // Border radius similar to CustomTextFieldV2
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: widget.focusedBorderColor,
                width: 2,
              ),
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

  // Function to open date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDateSelected(pickedDate);
    }
  }
}
