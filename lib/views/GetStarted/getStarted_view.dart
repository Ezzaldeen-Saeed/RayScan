import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/main.dart';

class getStarted_view extends StatefulWidget {
  const getStarted_view({super.key});

  @override
  _getStarted_viewState createState() => _getStarted_viewState();
}

class _getStarted_viewState extends State<getStarted_view> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                Page(
                    pageController: _pageController,
                    BGPath: 'assets/BGs/Start 1.png',
                    mainText: 'Track Your Health Throughout Your Life.',
                    subText:
                        'This app helps you discover key insights for a healthier life.'),
                Page(
                    pageController: _pageController,
                    BGPath: 'assets/BGs/Start 2.png',
                    mainText:
                        'Save your time and effort and use the Ray Scan app.',
                    subText:
                        'it saves you the need to go to the radiology center and saves time.'),
                Page(
                    pageController: _pageController,
                    BGPath: 'assets/BGs/Start 3.png',
                    mainText:
                        'Find out your radiation levels as quickly as possible',
                    subText:
                        'You can know the result of your x-ray in a very short time compared to x-ray centers and more clearly.'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3, // Number of pages
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final PageController pageController;
  final String BGPath, mainText, subText;

  const Page(
      {super.key,
      required this.pageController,
      required this.BGPath,
      required this.mainText,
      required this.subText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(BGPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: 320,
                  child: Text(
                    mainText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: 320,
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                nextButton(pageController: pageController),
              ],
            ))
      ],
    );
  }
}

class nextButton extends StatelessWidget {
  final PageController pageController;

  const nextButton({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(pageController.page!.toInt());
        if (pageController.page!.toInt() < 2) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          // Navigate to the home screen
          context.go('/login');
          hs.setFirstTime();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 30.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
