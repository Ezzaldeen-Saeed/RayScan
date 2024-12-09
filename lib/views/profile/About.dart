import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';

class About_subview extends StatefulWidget {
  About_subview({super.key});

  @override
  State<About_subview> createState() => _About_subviewState();
}

class _About_subviewState extends State<About_subview> {
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
          title: CustomText("About", 1)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: Image.asset(
                  'assets/others/Icon.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 33),
              IconText("RAY SCAN", size: 30),
              const SizedBox(height: 25),
              CustomText("Version 1.0", 2),
            ],
          ),
        ),
      ),
    );
  }
}
