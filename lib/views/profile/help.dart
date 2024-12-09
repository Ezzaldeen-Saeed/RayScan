import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';

class Help_subview extends StatefulWidget {
  Help_subview({super.key});

  @override
  State<Help_subview> createState() => _Help_subviewState();
}

class _Help_subviewState extends State<Help_subview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: CustomText("Help", 1)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
