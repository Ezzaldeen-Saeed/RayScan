import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';

class CustomSelectBox extends StatelessWidget {
  const CustomSelectBox({
    super.key,
    required this.items,
    required this.label,
    this.hint = '',
    this.onChanged,
    this.selectedValue,
    this.backgroundColor = lightModeBG1,
    this.focusedBorderColor = primaryColor,
    this.isIconed = false,
    this.icon,
  });

  final List<String> items; // List of items for the dropdown
  final String label; // Label for the select box
  final String hint; // Hint text for the select box
  final String? selectedValue; // Currently selected value
  final void Function(String?)? onChanged; // Callback when an item is selected
  final Color backgroundColor; // Background color of the dropdown
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
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: items
              .map((item) =>
              DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
              .toList(),
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
          dropdownColor: backgroundColor, // Dropdown background color
        ),
      ),
    );
  }
}
