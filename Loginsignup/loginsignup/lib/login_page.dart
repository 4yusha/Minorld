import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginsignup/Home_page.dart';
import 'package:loginsignup/Signup_page.dart';
import 'package:loginsignup/forgot_p_code_page.dart';

// Main Login Widget
// ignore: must_be_immutable
class MyLogin extends StatelessWidget {
  MyLogin({Key? key})
      : super(
            key:
                key); //constructor for MyLogin class which takes an optional 'key' parameter

  TextEditingController emailController =
      TextEditingController(); //input for handling email address
  TextEditingController createPasswordController =
      TextEditingController(); //input for handling password

  // Function to handle user login
  Future<void> Login_user(BuildContext context) async {
    //asynchronous function named 'Login_user' which takes a 'BuildContext' parameter
    String url =
        "http://192.168.1.70:5000/login/"; //define url endpoint for the login API

    Map<String, String> loginData = {
      // Creating a map named loginData to hold the email and password entered by the user.
      'email': emailController.text,
      'createPassword': createPasswordController.text,
    };

    try {
      http.Response response = await http.post(
        // Making a POST request to the login API using the http.post function from the http package. The request body contains the login data encoded in JSON format.
        Uri.parse(url),
        body: jsonEncode(loginData),
        headers: {"Content-Type": "application/json"},
      );

      // Handling different status codes received from the server
      if (response.statusCode == 200) {
        print('Login successfully');
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Minorld"),
            content: const Text('Login Successfully'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to home page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home_page(
                                name: '',
                                email: '',
                                avatar: 'assets/Avatar/Snake.png',
                              )));
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 400) {
        print('Please fill all the fields');
        // Show error dialog for incomplete fields
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
        print("Password doesn't match");
        // Show error dialog for incorrect password
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
        print("Invalid email address");
        // Show error dialog for invalid email
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
        print('Login failed');
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text('An error occurred, please try again later'),
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
          'An error occurred: $error'); // Handle any error that occurs during login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loginsignup1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              _buildHeader(), // Widget for Minorld Header
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.mail),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: createPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.key),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 70,
                      width: 330,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 45, 58, 95),
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () => Login_user(context)),
                    ),
                    SizedBox(height: 85),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Navigate to sign up page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signup_page(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Color.fromARGB(255, 45, 58, 95),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to forgot password page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => forgotPCode_page(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Color.fromARGB(255, 45, 58, 95),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Minorld Header
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Minorld',
          style: TextStyle(
            color: Color.fromARGB(255, 45, 58, 95),
            fontSize: 50,
          ),
        ),
        SizedBox(height: 10),
        Image.asset(
          'assets/minorld_logo.png',
          width: 200,
        ),
      ],
    );
  }

  // Widget for Minorld Input Field
  Widget _buildMinorldInput({
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 239, 239),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
