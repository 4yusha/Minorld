import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InspirePage extends StatefulWidget {
  final Map<String, String> initialData;
  final int postId;

  const InspirePage({
    Key? key,
    required this.initialData,
    required this.postId,
  }) : super(key: key);

  @override
  State<InspirePage> createState() => _InspirePageState();
}

class _InspirePageState extends State<InspirePage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with initial data
    titleController.text = widget.initialData['title'] ?? '';
    textController.text = widget.initialData['text'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          // Preview button
          FloatingActionButton.large(
            onPressed: null,
            child: Text(
              "Preview",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 45, 58, 95),
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            // Title input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title cannot be empty.";
                  } else if (value.length > 100) {
                    return "Title cannot be more than 100 characters";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                  labelText: "Add Title",
                  prefixIcon: IconButton(
                    onPressed: () {}, // Dummy onPressed
                    icon: Icon(
                      Icons.image,
                      color: Color.fromARGB(255, 45, 58, 95),
                    ),
                  ),
                ),
                maxLength: 500,
                maxLines: null,
              ),
            ),
            // Text input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: textController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Text can't be empty.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 45, 58, 95),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                  labelText: "Write a text to share.",
                ),
                maxLines: null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Post button
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : InkWell(
                    onTap: () {
                      if (_globalKey.currentState!.validate()) {
                        _postContent(context);
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 45, 58, 95),
                        ),
                        child: Center(
                          child: Text(
                            "Post",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Function to post content
  Future<void> _postContent(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String url = "http://192.168.1.65:5000/post";

    Map<String, dynamic> postData = {
      'postId': widget.postId,
      'title': titleController.text,
      'text': textController.text,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(postData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Show success message and save posted data to SharedPreferences
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Content posted successfully')),
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('postedData', jsonEncode(postData));

        Navigator.pop(context, postData);
      } else {
        // Show error message if posting failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post content')),
        );
      }
    } catch (error) {
      // Show error message if an error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
