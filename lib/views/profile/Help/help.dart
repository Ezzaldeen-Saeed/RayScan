import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testnav/main.dart';
import 'package:testnav/views/Feedback/feedback_veiw.dart';
import 'package:testnav/views/profile/Help/data.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/toggleButton.dart';

class Help_subview extends StatefulWidget {
  const Help_subview({super.key});

  @override
  State<Help_subview> createState() => _HelpSubviewState();
}

class _HelpSubviewState extends State<Help_subview> {
  final List<bool> _isSelected = [true, false];
  final List<bool> _isSelected2 = [true, false, false];
  double boxHeight = 220;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";
  List<Map<String, String>> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.toLowerCase() == "feedback") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => feedback_veiw()));
        _searchController.clear();
      }
      setState(() {
        _searchQuery = _searchController.text;
        _filterQuestions();
      });
    });
    _filterQuestions(); // Initial filtering
  }

  void _filterQuestions() {
    final currentCategory =
        HelpFAQData.helpTopics.keys.toList()[_isSelected2.indexOf(true)];
    final allQuestions = HelpFAQData.helpTopics[currentCategory] ?? [];
    _filteredQuestions = allQuestions
        .where((q) =>
            q['q']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            q['a']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      body: ListView(
        children: [
          Container(
            height: boxHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF4A9FCF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Center(
                            child: CustomText(
                              "Help Center",
                              1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 48,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomText("How Can We Help You", 3, color: Colors.white),
                  const SizedBox(height: 20),
                  _isSelected[1]
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                              boxShadow: const [
                                BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: secondaryColor),
                                prefixIcon:
                                    Icon(Icons.search, color: primaryColor),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 33),
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
                          boxHeight = _isSelected[0] ? 220 : 130;
                        }
                      });
                    },
                    padding: 16.0,
                  ),
                ],
              ),
            ),
          ),
          _isSelected[0] ? _FAQ_tab() : _contactUsTab(context),
        ],
      ),
    );
  }

  Widget _FAQ_tab() {
    final List<String> labels = HelpFAQData.helpTopics.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomToggleButtons(
                    labels: labels,
                    isSelected: _isSelected2,
                    onToggle: (int index) {
                      setState(() {
                        for (int i = 0; i < _isSelected2.length; i++) {
                          _isSelected2[i] = i == index;
                        }
                        _filterQuestions(); // Update the filtered questions
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
          HelpFAQWidget(questions: _filteredQuestions),
        ],
      ),
    );
  }

  Widget _contactUsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _listTile(Icons.headset_mic, "Customer Service",
              "rayscanmobileapp@gmail.com"),
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

  Widget _listTile(IconData icon, String title, String data) {
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
        onTap: () => _copyInfo(data),
      ),
    );
  }

  Future<void> _copyInfo(String data) async {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to Clipboard")),
    );
  }
}
