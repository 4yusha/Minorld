import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loginsignup/pages/comment_page.dart';
import 'package:loginsignup/pages/inspire_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    // Call method to fetch data
    fetchData();
  }

  void fetchData() async {
    // Load data from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? postedData = prefs.getString('postedData');
    if (postedData != null) {
      setState(() {
        // Convert posted data from string to map
        List<dynamic> decodedData = jsonDecode(postedData);
        data.addAll(decodedData.cast<Map<String, dynamic>>());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Post ID: ${data[index]['postId'].toString()}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              data[index]['title'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              data[index]['text'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final updatedData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InspirePage(
                                    initialData: {},
                                    postId: data[index]['postId'],
                                  ),
                                ),
                              );
                              if (updatedData != null) {
                                setState(() {
                                  data[index] = updatedData;
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('postedData', jsonEncode(data));
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                if (index >= 0 && index < data.length) {
                                  data.removeAt(index);
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setString(
                                        'postedData', jsonEncode(data));
                                  });
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () async {
                              final newComment = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentPage(
                                    username: '',
                                  ),
                                ),
                              );
                              if (newComment != null) {
                                setState(() {
                                  // Add the new comment to the post
                                  if (data[index]['comments'] == null) {
                                    data[index]['comments'] = [newComment];
                                  } else {
                                    data[index]['comments'].add(newComment);
                                  }
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('postedData', jsonEncode(data));
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Generate a unique postId
          int postId = data.isEmpty ? 1 : data.length + 1;

          final newData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InspirePage(
                initialData: {},
                postId: postId,
              ),
            ),
          );

          if (newData != null) {
            setState(() {
              data.add(newData);
            });

            // Convert new data to map and store it in shared preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('postedData', jsonEncode(data));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
