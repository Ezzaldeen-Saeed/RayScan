import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/miniProfileCard.dart';

class HomeView extends StatelessWidget {
  final AuthService auth = AuthService();

  final SignUpAndLogin signupLogin = SignUpAndLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2F80ED), Color(0xFFB2FFDA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  //make the color gradiant
                  gradient: LinearGradient(
                    colors: [Color(0xFF4898e9), Color(0xFFb1feda)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(200.0),
                    bottomRight: Radius.circular(200.0),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: ListView(
              children: [
                MiniProfileCard(onPressed: () {
                  GoRouter.of(context).go('/profile');
                }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Patient:',
                        style: TextStyle(
                          color: currentTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
