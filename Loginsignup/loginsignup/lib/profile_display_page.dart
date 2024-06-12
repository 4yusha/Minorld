import 'package:flutter/material.dart';

class ProfileDisplayPage extends StatelessWidget {
  final String name;
  final String email;
  final String avatar;

  const ProfileDisplayPage({
    required this.name,
    required this.email,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"), // Setting the title of the app bar
        backgroundColor:
            Color.fromARGB(255, 45, 58, 95), // Setting app bar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage(avatar), // Displaying the user's avatar
            ),
            SizedBox(height: 20), // Adding space between avatar and text
            Text("Name: $name"), // Displaying user's name
            Text("Email: $email"), // Displaying user's email
          ],
        ),
      ),
    );
  }
}
