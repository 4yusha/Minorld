import 'package:flutter/material.dart';
import 'package:loginsignup/login_page.dart';
import 'package:loginsignup/pages/chat_page.dart';
import 'package:loginsignup/pages/inspire_page.dart';
import 'package:loginsignup/pages/main_page.dart';
import 'package:loginsignup/profile_display_page.dart';
import 'package:loginsignup/profile_page.dart';

// Home Page Widget
// ignore: must_be_immutable
class Home_page extends StatefulWidget {
  String email;
  final String avatar;

  // Constructor
  Home_page({
    Key? key,
    required String name,
    required this.email,
    required this.avatar,
  })  : name = name, // Initialize name in the constructor
        super(key: key);

  String name; // Declare name here, not as a field

  @override
  _MainPageState createState() => _MainPageState();
}

// State for Home Page Widget
class _MainPageState extends State<Home_page> {
  int _selectedIndex = 0;

  // List of widgets for different sections
  static final List<Widget> _sections = <Widget>[
    const ChatPage(), // Chat Page
    const MainPage(), // Main Page
  ];

  // Function to handle navigation when bottom navigation bar item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minorld'), // AppBar title
        backgroundColor:
            const Color.fromARGB(255, 45, 58, 95), // AppBar background color
        actions: [
          // Profile icon to navigate to saved profile page
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDisplayPage(
                    name: widget.name,
                    email: widget.email,
                    avatar: widget.avatar,
                  ),
                ),
              );
            },
            icon: Icon(Icons.account_circle), // Profile icon
          ),
        ],
      ),
      body: Center(
        child: _sections.elementAt(_selectedIndex), // Display selected section
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded), // Chat icon
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_half), // Inspire icon
            label: 'Inspire',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle bottom navigation bar item tap
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 45, 58, 95),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Create and Update Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      onUpdateProfile:
                          (String updatedName, String updatedEmail) {
                        setState(() {
                          widget.name = updatedName;
                          widget.email = updatedEmail;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the notifications page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => (),
                //   ),
                // );
              },
            ),
            ListTile(
              title: const Text('Do post'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the inspire page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InspirePage(initialData: {}, postId: 1),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the settings page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => (),
                //   ),
                // );
              },
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                Navigator.pop(context);
                //   Navigate to the settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyLogin(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
