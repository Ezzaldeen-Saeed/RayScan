import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/button.dart';

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  final AuthService auth = AuthService();

  SignUpAndLogin signupLogin = SignUpAndLogin();

  @override
  Widget build(BuildContext context) {
    // Access the global controller
    return Scaffold(
      backgroundColor: currentBG,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonIcon(
              radius: 200,
              buttonColor: Colors.blue,
              icon: Icons.add_a_photo_outlined,
              onPressed: () => context.go('/addPatient/imageUpload_subview'),
            ),
            const SizedBox(height: 20),
            Text("Upload Patient Images", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
