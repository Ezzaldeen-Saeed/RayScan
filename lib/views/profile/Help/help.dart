import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/views/profile/Help/data.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/toggleButton.dart';
import 'package:url_launcher/url_launcher.dart';

class Help_subview extends StatefulWidget {
  const Help_subview({super.key});

  @override
  State<Help_subview> createState() => _HelpSubviewState();
}

class _HelpSubviewState extends State<Help_subview> {
  final List<bool> _isSelected = [true, false];
  final List<bool> _isSelected2 = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      body: ListView(
        children: [
          // Rounded rectangle background with AppBar and search area
          Container(
            height: 240, // Controls height for AppBar + search area
            decoration: BoxDecoration(
              color: const Color(0xFF4A9FCF), // Background color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // AppBar Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Back Button
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),

                        // Centered Title
                        Expanded(
                          child: Center(
                            child: CustomText(
                              "Help Center",
                              1,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Placeholder for symmetry
                        SizedBox(
                          width: 48, // Equal to the width of the IconButton
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  CustomText("How Can We Help You", 3, color: Colors.white),

                  const SizedBox(height: 20),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: secondaryColor),
                          prefixIcon: Icon(Icons.search, color: primaryColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 33),

          // FAQ & Contact Us Section
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomToggleButtons(
                    labels: ['FAQ', 'Contact Us'],
                    isSelected: _isSelected,
                    onToggle: (int index) {
                      setState(() {
                        for (int i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = i == index;
                        }
                      });
                    },
                    padding: 16.0,
                  ),
                ],
              ),
            ),
          ),
          // Body Content
          _isSelected[0] ? _FAQ_tab() : _contactUsTab(),
        ],
      ),
    );
  }

  Widget _FAQ_tab() {
    final List<String> labels = HelpFAQData.helpTopics.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(20.0), // Optional padding for spacing
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              // Center the content inside the scroll view
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Center the Row content
                children: [
                  CustomToggleButtons(
                    labels: labels,
                    isSelected: _isSelected2,
                    onToggle: (int index) {
                      setState(() {
                        for (int i = 0; i < _isSelected2.length; i++) {
                          _isSelected2[i] = i == index;
                        }
                      });
                    },
                    padding: 16.0,
                    type: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          HelpFAQWidget(category: labels[_isSelected2.indexOf(true)]),
        ],
      ),
    );
  }

  Widget _contactUsTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _listTile(Icons.headset_mic, "Customer Service",
              "mailto:rayscanmobileapp@gmail.com"),
          _listTile(Icons.public, "Website", "https://www.example.com"),
          _listTile(Icons.phone, "Whatsapp", "https://wa.me/919999999999"),
          _listTile(Icons.facebook, "Facebook",
              "https://www.facebook.com/profile.php?id=61569808950229"),
          _listTile(Icons.camera_alt, "Instagram",
              "https://www.instagram.com/rayscanmobileapp/"),
        ],
      ),
    );
  }

  Widget _listTile(IconData icon, String title, String url) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFBEE3F3),
          child: Icon(icon, color: const Color(0xFF4A9FCF)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded,
            color: Colors.black54),
        onTap: () => _launchUrl(url),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Debugging: Print the URI being launched
      debugPrint('Attempting to launch: $uri');

      // Check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Ensures external app is used
        );
      } else {
        throw 'Cannot launch $url. Ensure the app to handle this action is installed.';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Show user-friendly error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not open the link.')),
      );
    }
  }
}
