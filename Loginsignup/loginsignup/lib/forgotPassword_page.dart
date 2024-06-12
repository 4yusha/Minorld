import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginsignup/login_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Controllers for text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Function to reset the password
  Future<void> resetPassword(BuildContext context) async {
    String url = "http://192.168.1.65:5000/reset_password/";

    Map<String, String> loginData = {
      'email': emailController.text,
      'reset_otp': otpController.text,
      'newPassword': newPasswordController.text,
      'confirmPassword': confirmPasswordController.text,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(loginData),
        headers: {"Content-Type": "application/json"},
      );

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Password reset successful
        print('Password has been reset successfully.');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Minorld"),
            content: const Text('Password has been reset successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyLogin()));
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 400) {
        // Fields are not filled
        print('Please fill all the fields');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text('Please fill all the fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 401) {
        // Passwords do not match
        print("Password doesn't match");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text("Password doesn't match"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 404) {
        // Invalid email address
        print("Invalid email address");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text("Invalid email address"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Password reset failed
        print('Password has not been reset.');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text('An error occur, please try in later'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Catch any error that occurs during password reset
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/loginsignup1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Title of the page
            Container(
              padding: const EdgeInsets.only(left: 30, top: 180),
              child: const Text(
                'Reset Account Password',
                style: TextStyle(
                  color: Color.fromARGB(255, 45, 58, 95),
                  fontSize: 25,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3,
                  right: 35,
                  left: 35,
                ),
                child: Column(
                  children: [
                    // Email input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),

                    // OTP input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: 'OTP',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),

                    // New password input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: newPasswordController,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),

                    // Confirm new password input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Confirm New Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Button to reset password
                    Container(
                      height: 70,
                      width: 330,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 45, 58, 95)),
                        ),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () => resetPassword(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
