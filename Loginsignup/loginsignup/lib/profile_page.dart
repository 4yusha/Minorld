import 'package:flutter/material.dart';
import 'package:loginsignup/Home_page.dart';
import 'package:loginsignup/profile_display_page.dart';

class ProfilePage extends StatefulWidget {
  final Function(String, String) onUpdateProfile;

  const ProfilePage({Key? key, required this.onUpdateProfile})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isObscurePassword = true;
  TextEditingController nameController =
      TextEditingController(); // Controller for name input field
  TextEditingController emailController =
      TextEditingController(); // Controller for email input field
  TextEditingController createPasswordController =
      TextEditingController(); // Controller for password input field
  String selectedAvatar = 'assets/Avatar/Snake.png'; // Default selected avatar

  // Function to update the profile and navigate to the profile display page
  Future<void> updateProfile(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    // Retrieve updated name and email data
    String updatedName = nameController.text;
    String updatedEmail = emailController.text;

    // Call the callback function to pass the updated data to the parent widget
    widget.onUpdateProfile(updatedName, updatedEmail);

    // Navigate to the profile display page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDisplayPage(
          name: nameController.text,
          email: emailController.text,
          avatar: selectedAvatar,
        ),
      ),
    );
  }

  // Function to build avatar widget with onTap functionality
  Widget buildAvatar(String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = imagePath;
        });
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.white),
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
            )
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }

  // Function to validate credentials (dummy implementation, always returns true)
  Future<bool> validateCredentials(String email, String password) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Color.fromARGB(255, 45, 58, 95),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    // Avatar display with edit icon
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(selectedAvatar))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            color: Colors.blue),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Text fields for name, email, and password
              buildTextField("Full Name", "Lauran Schnapp", false,
                  controller: nameController),
              buildTextField("Email", "lauranschnapp22@gmail.com", false,
                  controller: emailController),
              buildTextField("Password", "********", true,
                  controller: createPasswordController),
              SizedBox(height: 30),
              // Buttons for cancel and save actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate to the previous screen
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Call the updateProfile function
                      await updateProfile(context);
                      // Navigate to Home_page and pass the profile data
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home_page(
                            name: nameController.text,
                            email: emailController.text,
                            avatar: selectedAvatar,
                          ),
                        ),
                      );
                    },
                    child: Text("SAVE",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 45, 58, 95),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build text field with optional password visibility
  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField,
      {TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ))
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
