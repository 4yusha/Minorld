import 'package:flutter/material.dart';
import 'package:loginsignup/login_page.dart';
import 'package:loginsignup/pages/inspire_page.dart';

void main() {
  var postId = 0; // Initializing postId with a default value
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {'login': (context) => MyLogin()},
    home: InspirePage(
      initialData: {},
      postId: postId,
    ),
  ));
}
