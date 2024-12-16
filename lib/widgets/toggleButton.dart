import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';

class CustomToggleButtons extends StatelessWidget {
  final List<String> labels; // Text labels for each button
  final List<bool> isSelected; // State of each toggle button
  final void Function(int) onToggle; // Callback when a button is toggled
  final double padding; // Padding for each button
  final Color color; // Default text color
  final Color selectedColor; // Text color for selected buttons
  final Color fillColor; // Background color for selected buttons
  final Color borderColor; // Border color for all buttons
  final BorderRadius borderRadius; // Border radius for buttons
  final double spacing; // Space between buttons
  final int type;

  const CustomToggleButtons({
    super.key,
    required this.labels,
    required this.isSelected,
    required this.onToggle,
    this.padding = 16.0,
    this.color = Colors.black,
    this.selectedColor = Colors.white,
    this.fillColor = const Color(0xFF4A9FCF),
    this.borderColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.spacing = 10.0,
    this.type = 1,
  });

  final BoxConstraints constraints1 =
      const BoxConstraints(minWidth: 120, minHeight: 40);
  final BoxConstraints constraints2 =
      const BoxConstraints(minWidth: 100, minHeight: 25);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: currentBG, // Background color
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : spacing, // Add spacing between buttons
            ),
            child: GestureDetector(
              onTap: () => onToggle(index),
              child: Container(
                padding: type == 1
                    ? EdgeInsets.symmetric(horizontal: padding, vertical: 10)
                    : null,
                constraints: type == 1 ? constraints1 : constraints2,
                decoration: BoxDecoration(
                  color: isSelected[index] ? fillColor : unselectedButton,
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: borderColor,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected[index] ? selectedColor : fillColor,
                      fontSize: type == 1 ? 16 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
