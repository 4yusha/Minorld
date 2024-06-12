import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key, required String username}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Comment'),
        backgroundColor: Color.fromARGB(255, 45, 58, 95),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _commentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter your comment',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass back the entered comment when the button is pressed
                Navigator.pop(context, {
                  'comment': _commentController.text,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 45, 58, 95),
              ),
              child: Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
