import 'package:flutter/material.dart';
import 'package:loginsignup/Signup_page.dart';
import 'package:loginsignup/forgot_password_page.dart';
import 'package:loginsignup/login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class forgotPCode_page extends StatefulWidget {
  forgotPCode_page({Key? key});

  @override
  State<forgotPCode_page> createState() => _forgotPCode_pageState();
}

class _forgotPCode_pageState extends State<forgotPCode_page> {
  TextEditingController emailController = TextEditingController();

  Future<void> forgotPassword(BuildContext context) async {
    String url = "http://192.168.1.70:5000/forgot_password/";

    Map<String, String> resetData = {
      'email': emailController.text,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(resetData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('OTP sent.'); // Print message if OTP is sent successfully
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Minorld"),
            content: const Text(
                'OTP sucessfully sent.'), // Dialog content for OTP sent successfully
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 400) {
        print(
            'Please provide an email address'); // Print message if email address is missing
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text(
                'Please provide an email address'), // Dialog content for missing email address
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 404) {
        print("User doesn't exist"); // Print message if user doesn't exist
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text(
                "User doesn't exist."), // Dialog content for user not existing
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Sending failed'); // Print message if sending OTP failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text(
                'Sending Failed'), // Dialog content for sending OTP failed
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
      print(
          'An error occurred: $error'); // Print error message if any error occurs during the process
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
            Container(
              padding: const EdgeInsets.only(left: 30, top: 180),
              child: const Text(
                'Forgot Password',
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
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Setting border color for input field
                          ),
                          filled: true, // Filling input field with white color
                          fillColor: Colors
                              .white, // Setting input field background color
                          prefixIcon: Icon(Icons
                              .person), // Adding person icon as prefix to input field
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
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
                          'Send message',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () => forgotPassword(
                            context)), // Call forgotPassword function when button is pressed
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signup_page(),
                              ));
                        },
                        child: Text(
                          'Sign Up', // Text for Sign Up button
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                            color: Color.fromARGB(255, 45, 58, 95),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyLogin(),
                              ));
                        },
                        child: const Text(
                          'Have an account?', // Text for Have an account? button
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                            color: Color.fromARGB(255, 45, 58, 95),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
