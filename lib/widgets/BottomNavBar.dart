import 'dart:developer';

import 'package:flutter/material.dart';
import '../utils/Utility.dart';
import 'colors.dart';

// System Variable
const int _addPatientIndex = 0;
const int _homeIndex = 1;
const int _searchIndex = 2;
const int _profileIndex = 3;

class CustomBottomNavBar extends StatelessWidget {

  const CustomBottomNavBar(int i, {super.key});
  final int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("Navigator Info: ${Navigator.of(context)}");
      log("Navigator Stack Info: ${Navigator.of(context).widget}");
      log("Route Info: ${ModalRoute.of(context)?.settings.name}");
    });

    return BottomNavigationBar(
      backgroundColor: Colors.red, // Set a distinct color for testing
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          label: 'Add Patient',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case _addPatientIndex:
            UtilityManager.goToAddPatient(context);
            log(Navigator.of(context).toString());
            break;
          case _homeIndex:
            UtilityManager.goToHome(context);
            log(Navigator.of(context).toString());
            break;
          case _searchIndex:
            UtilityManager.goToSearch(context);
            log(Navigator.of(context).toString());
            break;
          case _profileIndex:
            UtilityManager.goToProfile(context);
            log(Navigator.of(context).toString());
            break;
        }
      },
    );
  }
}
