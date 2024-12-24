import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/miniProfileCard.dart';

import '../../widgets/pallet.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthService auth = AuthService();
  final String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

  int numberOfPatients = 0;
  int numberOfMalePatients = 0;
  int numberOfFemalePatients = 0;
  double averageAge = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    final patients = await auth.getNumberOfPatientsForCurrentUser();
    final males = await auth.getNumberOfMalePatients();
    final females = await auth.getNumberOfFemalePatients();
    final avgAge = await auth.getAverageAgeOfPatients();

    setState(() {
      numberOfPatients = patients;
      numberOfMalePatients = males;
      numberOfFemalePatients = females;
      averageAge = avgAge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MiniProfileCard(onPressed: () {}),
            // Add padding to elements beneath MiniProfileCard
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // GridView for displaying data
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final colors = [
                      [Colors.redAccent, Colors.red],
                      [Colors.purpleAccent, Colors.purple],
                      [Colors.blueAccent, Colors.blue],
                      [Colors.greenAccent, Colors.green],
                    ];
                    final data = [
                      '$numberOfPatients Patients',
                      '$numberOfMalePatients Males',
                      '$numberOfFemalePatients Females',
                      'Avg Age: ${averageAge.toStringAsFixed(1)}',
                    ];
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors[index],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -30,
                            right: -20,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: -30,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              data[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(child: Image.asset("assets/others/img.png" , width: 220,)),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
