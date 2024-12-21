import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/customSnackbar.dart';
import 'package:testnav/widgets/textfield.dart';

class feedback_veiw extends StatefulWidget {
  const feedback_veiw({Key? key}) : super(key: key);

  @override
  State<feedback_veiw> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<feedback_veiw>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  int rating = 0;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Image(
            image: AssetImage('assets/others/secret.jpg'),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Center(
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    textAlign: TextAlign.center,
                    "Feedback",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                    child: Column(
                      children: [
                        SlideTransition(
                          position: _slideAnimation,
                          child: CustomTextFieldV2(
                            type: 1,
                            hint: "Enter Your Name",
                            backgroundColor: Colors.black.withOpacity(0.5),
                            controller: nameController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SlideTransition(
                          position: _slideAnimation,
                          child: CustomTextFieldV2(
                            type: 1,
                            hint: "Enter Your Feedback",
                            backgroundColor: Colors.black.withOpacity(0.5),
                            controller: feedbackController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF4898e9).withOpacity(0.5),
                                  const Color(0xFFb1feda).withOpacity(0.5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Rate By Emojis For Some Reason",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  const SizedBox(height: 20),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(5, (index) {
                                        final icons = [
                                          Icons.sentiment_very_dissatisfied,
                                          Icons.sentiment_dissatisfied,
                                          Icons.sentiment_neutral,
                                          Icons.sentiment_satisfied,
                                          Icons.sentiment_very_satisfied
                                        ];
                                        final colors = [
                                          Colors.red,
                                          Colors.orange,
                                          Colors.yellow,
                                          Colors.lightGreen,
                                          Colors.green
                                        ];
                                        final sizes = [
                                          10.0,
                                          20.0,
                                          30.0,
                                          40.0,
                                          50.0
                                        ];

                                        return IconButton(
                                          onPressed: () {
                                            setState(() {
                                              rating = index + 1;
                                            });
                                          },
                                          icon: Icon(
                                            icons[index],
                                            color: colors[index],
                                          ),
                                          iconSize: rating == index + 1
                                              ? sizes[index] * 1.5
                                              : sizes[index],
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Totally Normal Right?",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                        CustomButton(
                          onPressed: () {
                            _submit(context);
                          },
                          label: 'Submit',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _submit(BuildContext context) async {
    AuthService auth = AuthService();
    auth
        .feedback(nameController.text, feedbackController.text, rating)
        .then((value) {
      if (value) {
        CustomSnackbar(
          title: 'Thank you for your feedback',
          actionLabel: "Undo",
          backgroundColor: Colors.white,
          fontColor: Colors.black,
          hasAction: false,
          onPressAction: () {},
        ).show(context);
        Navigator.pop(context);
      } else {
        // Handle error
      }
    });
  }
}
