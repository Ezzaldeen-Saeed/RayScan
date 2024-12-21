import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:testnav/widgets/customDialog.dart';
import 'package:testnav/widgets/pallet.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  late AnimationController _animationController;
  late Animation<double> _animation;

  int selectedIndex = 1;
  String statusText = 'Checking connectivity...';
  Color statusColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      checkConnectivity(result.first);
    });
  }

  Future<void> checkConnectivity(ConnectivityResult result) async {
    setState(() {
      statusText = 'Checking internet access...';
    });

    bool hasInternet = await _hasInternetConnection();

    if (hasInternet) {
      switch (result) {
        case ConnectivityResult.mobile:
          setState(() {
            statusText = 'Connected to Mobile Data with Internet';
            statusColor = Colors.blue;
          });
          break;
        case ConnectivityResult.wifi:
          setState(() {
            statusText = 'Connected to WiFi with Internet';
            statusColor = Colors.green;
          });
          break;
        default:
          setState(() {
            statusText = 'Unknown Network with Internet';
            statusColor = Colors.orange;
          });
      }
    } else {
      setState(() {
        statusText = 'No Internet Connection';
        statusColor = Colors.red;
        _showStyledAlert(context);
      });
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _showStyledAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: "No Internet Connection",
          continueButtonChild: const Text("Continue Without Internet",
              style: TextStyle(color: Colors.white)),
          animation: _animation,
          onContinue: () {
            Navigator.of(context).pop();
          },
          hasHint: true,
          onHintTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                    title:
                        "Some Features May Not Work Like:\nAdding Patient, Searching, Modifying, Deleting, etc.",
                    continueButtonChild:
                        const Icon(Icons.check, color: Colors.white),
                    onContinue: () {
                      Navigator.of(context).pop();
                    },
                    hasHint: false,
                    onHintTap: () {},
                    backgroundColor: infoAlertDialogBg,
                    fontColor: infoAlertDialogFont);
              },
            );
          },
          backgroundColor: errorAlertDialogBg,
          fontColor: errorAlertDialogFont,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          _goBranch(selectedIndex);
        },
        iconSize: 30,
        backgroundColor: primaryColor,
        inactiveColor: Colors.white,
        activeColor: Colors.white,
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.person_add,
            title: 'Add Patient',
          ),
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
            icon: Icons.search,
            title: 'Search',
          ),
          BarItem(
            icon: Icons.account_circle,
            title: 'Profile',
          ),
        ],
      ),
    );
  }
}
