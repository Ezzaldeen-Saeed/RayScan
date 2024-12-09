import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';

class Passwordmanager_subview extends StatefulWidget {
  Passwordmanager_subview({super.key});

  @override
  State<Passwordmanager_subview> createState() =>
      _Passwordmanager_subviewState();
}

class _Passwordmanager_subviewState extends State<Passwordmanager_subview> {
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
          title: CustomText("Password Manager", 1)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 33),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText("Current Password", 1.2),
            ),
            CustomTextFieldV2(type: 1.0, isPassword: true),
            const SizedBox(height: 33),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText("New Password", 1.2),
            ),
            CustomTextFieldV2(type: 1.0, isPassword: true),
            const SizedBox(height: 33),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText("Confirm New Password", 1.2),
            ),
            CustomTextFieldV2(type: 1.0, isPassword: true),
          ],
        ),
      ),
    );
  }
}
