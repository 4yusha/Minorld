import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loginsignup/login_page.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({Key? key}) : super(key: key);

  @override
  _Signup_pageState createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  // Text editing controllers for input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Function to register a user
  Future<void> registerUser(BuildContext context) async {
    String url = "http://192.168.1.65:5000/signup/";

    // User registration data
    Map<String, String> registrationData = {
      'name': nameController.text,
      'email': emailController.text,
      'createPassword': createPasswordController.text,
      'confirmPassword': confirmPasswordController.text,
    };

    try {
      // Send a POST request to register the user
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(registrationData),
        headers: {"Content-Type": "application/json"},
      );

      // Handle different status codes
      if (response.statusCode == 200) {
        // User registered successfully
        print('User registered successfully');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Minorld"),
            content: const Text('Register Successfully'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLogin()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 400) {
        // Fields validation failed
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
        // Passwords don't match
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
      } else if (response.statusCode == 402) {
        // User already exists
        print("User already exists");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Minorld'),
            content: const Text("User already exists"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Registration failed due to an error
        print('Register failed');
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
      // Handle any error that occurs during registration
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
            Container(
              padding: const EdgeInsets.only(left: 120, top: 120),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Color.fromARGB(255, 45, 58, 95),
                  fontSize: 40,
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
                    // Name input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                    // Email input field
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
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.message),
                          ),
                        ),
                      ),
                    ),
                    // Create Password input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: createPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Create Password',
                            hintStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                    // Confirm Password input field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                    // Sign Up button
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
                          'Sign Up',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          registerUser(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // Already have an account text
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyLogin(),
                            ));
                      },
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color.fromARGB(255, 45, 58, 95),
                        ),
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

  // Widget to build input field with icon
  Widget _buildMinorldInput(
      {required String hintText, required IconData icon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 239, 239),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.grey),
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
