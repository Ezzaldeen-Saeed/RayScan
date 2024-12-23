import 'package:flutter/material.dart';

class AnimatedPercentage extends StatefulWidget {
  final double percentage;
  final String topPrediction;

  const AnimatedPercentage({
    Key? key,
    required this.percentage,
    required this.topPrediction,
  }) : super(key: key);

  @override
  _AnimatedPercentageState createState() => _AnimatedPercentageState();
}

class _AnimatedPercentageState extends State<AnimatedPercentage> {
  double _displayPercentage = 0;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();

    // Delay the start of the animation
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showAnimation = true;
        _displayPercentage = widget.percentage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showAnimation) {
      // Show a placeholder or nothing before the animation starts
      return Text(
        "Calculating...",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _displayPercentage),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut, // Smooth deceleration at the end
      builder: (context, value, child) {
        return Text(
          widget.percentage > 0
              ? "${widget.topPrediction} : ${value.toStringAsFixed(1)}%"
              : "Free From Diseases.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.percentage > 0 ? Colors.red : Colors.green,
          ),
        );
      },
    );
  }
}
