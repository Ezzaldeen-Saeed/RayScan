import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testnav/widgets/colors.dart';

class CustomDateSelection extends StatelessWidget {
  const CustomDateSelection({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
    this.hint = 'Select a date',
    this.backgroundColor = lightModeBG1,
    this.focusedBorderColor = primaryColor,
    this.isIconed = false,
    this.icon,
  });

  final String label; // Label for the date picker
  final DateTime? selectedDate; // Currently selected date
  final void Function(DateTime)
      onDateSelected; // Callback when a date is selected
  final String hint; // Hint text
  final Color backgroundColor; // Background color of the field
  final Color focusedBorderColor; // Border color when focused
  final bool isIconed; // Determines if an icon is added
  final Icon? icon; // Icon to display (if `isIconed` is true)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            blurRadius: 2, // How soft the shadow is
            offset: const Offset(0, 2), // Offset in x and y direction
          ),
        ],
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(6),
        child: TextField(
          readOnly: true, // Disable text input
          controller: TextEditingController(
            text: selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                : '', // Format and display the selected date
          ),
          onTap: () async {
            // Show date picker dialog
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          decoration: InputDecoration(
            label: Text(label),
            hintText: hint,
            filled: true,
            fillColor: backgroundColor,
            // Background color
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            prefixIcon: isIconed ? icon : null,
            // Optional icon
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: focusedBorderColor,
                width: 2,
              ), // On-focus border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
