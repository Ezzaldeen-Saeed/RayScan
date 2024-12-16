import 'package:flutter/material.dart';

class HelpFAQData {
  static const Map<String, List<Map<String, String>>> helpTopics = {
    // 'Example Category': [
    //   {
    //     'q': 'Example Question 1',
    //     'a': 'Example Answer 1',
    //   },
    //   ],

    'Popular Topic': [
      {
        'q': 'How do I reset my password?',
        'a':
            'To reset your password, Go to Profile > Settings > Password Manager. Enter your current password and new password, then click on the "Save" button.'
      },
      {
        'q': 'How do I update my profile?',
        'a':
            'Unfortunately, you cannot update your profile at this time. Please contact customer service for assistance.'
      },
      {
        'q': 'How do I contact customer service?',
        'a':
            'To contact customer service, click on the "Contact Us" tab in the Profile > Help > Contact Us . You can contact customer service via email, phone, or social media.'
      },
      {
        'q': ' How does Ray Scan analyze X-ray images?',
        'a':
            'Ray Scan uses artificial intelligence to analyze X-ray images. The AI algorithm is trained on a large dataset of X-ray images to detect abnormalities and provide a diagnosis.',
      }
    ],
    'General': [
      {
        'q': 'What is Ray Scan?',
        'a':
            'Ray Scan is a medical imaging app that uses artificial intelligence to analyze X-ray images. The app can detect abnormalities in X-ray images and provide a diagnosis.'
      },
      {
        'q': 'How do I download the Ray Scan app?',
        'a':
            'To download the Ray Scan app, go to the App Store or Google Play Store and search for "Ray Scan." Click on the download button to install the app on your device.'
      },
      {
        'q': 'How do I create an account?',
        'a':
            'To create an account, click on the "Sign Up" link on the login page. You will be prompted to enter your name, email, and password to create an account.'
      },
      {
        'q': 'How do I log in to my account?',
        'a':
            'To log in to your account, enter your email and password on the login page. Click on the "Log In" button to access your account.'
      }
    ],
    'Services': [
      {
        'q': 'What services does Ray Scan offer?',
        'a':
            'Ray Scan offers medical imaging services, including X-ray analysis and diagnosis. The app uses artificial intelligence to analyze X-ray images and detect abnormalities.'
      },
      {
        'q': 'How accurate is Ray Scan?',
        'a':
            'Ray Scan is highly accurate in detecting abnormalities in X-ray images. The app uses artificial intelligence to analyze X-ray images and provide a diagnosis.'
      },
      {
        'q': 'How long does it take to get results from Ray Scan?',
        'a':
            'Results from Ray Scan are available instantly. The app uses artificial intelligence to analyze X-ray images and provide a diagnosis in real-time.'
      },
      {
        'q': 'How much does Ray Scan cost?',
        'a':
            'Ray Scan is free to download and use. There are no hidden fees or charges for using the app.'
      }
    ],
  };
}

class HelpFAQWidget extends StatelessWidget {
  final String category;

  const HelpFAQWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> questions =
        HelpFAQData.helpTopics[category] ?? [];

    return ListView.builder(
      key: ValueKey(category),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index]['q']!;
        final answer = questions[index]['a']!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              key: ValueKey('$category-$index'),
              // Unique key for each tile
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              collapsedIconColor: const Color(0xFF4A9FCF),
              title: Text(
                question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A9FCF),
                ),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
