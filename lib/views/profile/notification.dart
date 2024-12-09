import 'package:flutter/material.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';

class NotificationManager_subview extends StatefulWidget {
  NotificationManager_subview({super.key});

  @override
  State<NotificationManager_subview> createState() =>
      _NotificationManager_subviewState();
}

class _NotificationManager_subviewState
    extends State<NotificationManager_subview> {
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
          title: CustomText("Notification Settings", 1)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            CustomProfileToggle(label: 'General Notification'),
            const SizedBox(height: 33),
            CustomProfileToggle(label: 'Sound'),
            const SizedBox(height: 33),
            CustomProfileToggle(label: 'vibrate'),
            const SizedBox(height: 33),
            CustomProfileToggle(label: 'Special Offers'),
          ],
        ),
      ),
    );
  }
}
