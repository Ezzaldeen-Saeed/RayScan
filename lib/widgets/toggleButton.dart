import 'package:flutter/material.dart';

class CustomToggleButtons extends StatelessWidget {
  final List<String> labels; // Text labels for each button
  final List<bool> isSelected; // State of each toggle button
  final void Function(int) onToggle; // Callback when a button is toggled
  final double padding; // Padding for each button
  final Color color; // Default text color
  final Color fillColor; // Background color for selected buttons
  final Color borderColor; // Default border color
  final Color selectedBorderColor; // Border color for selected buttons
  final Color selectedColor; // Text color for selected buttons
  final Color splashColor; // Splash color for button tap effect
  final BorderRadius borderRadius; // Border radius for buttons
  final BoxConstraints constraints; // Constraints for button size

  const CustomToggleButtons({
    Key? key,
    required this.labels,
    required this.isSelected,
    required this.onToggle,
    this.padding = 16.0,
    this.color = Colors.black,
    this.fillColor = Colors.grey,
    this.borderColor = Colors.grey,
    this.selectedBorderColor = Colors.black,
    this.selectedColor = Colors.white,
    this.splashColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.constraints = const BoxConstraints(minWidth: 100, minHeight: 40),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: labels.map((label) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(label),
        );
      }).toList(),
      isSelected: isSelected,
      color: color,
      fillColor: fillColor,
      borderColor: borderColor,
      selectedBorderColor: selectedBorderColor,
      selectedColor: selectedColor,
      splashColor: splashColor,
      borderRadius: borderRadius,
      constraints: constraints,
      onPressed: onToggle,
    );
  }
}
