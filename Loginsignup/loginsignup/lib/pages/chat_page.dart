import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser myself = ChatUser(id: '1', firstName: 'You');
  ChatUser AI = ChatUser(id: '2', firstName: 'Minorld');

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final oururl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyB6IpHD1ea0guNKsccj3N29IoHOHrfuYMQ';
  final header = {'Content-Type': 'application/json'};

  // Define a variable to store a message to delete
  late ChatMessage messageToDelete = ChatMessage(
    text: '',
    user: ChatUser(id: ''),
    createdAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    // Load chat history when the widget initializes
    loadChatHistory();
  }

// Function to load chat history from SharedPreferences
  void loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatHistory = prefs.getString('chatHistory');
    if (chatHistory != null) {
      // Decode chat history from JSON and update the state
      List<dynamic> historyData = jsonDecode(chatHistory);
      setState(() {
        allMessages = historyData
            .map((message) => ChatMessage.fromJson(message))
            .toList();
      });
    }
  }

// Function to save chat history to SharedPreferences   
  void saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatHistory', jsonEncode(allMessages));
  }

// Function to get data from an API and add it to the chat
  Future<void> getdata(ChatMessage m) async {
    // Add typing indicator
    typing.add(AI);
    allMessages.insert(0, m);
    setState(() {});

    // Prepare data to send to API
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    try {
      // Send data to API and process response
      final response = await http.post(Uri.parse(oururl),
          headers: header, body: jsonEncode(data));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        // Create a new message from the API response
        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: AI,
            createdAt: DateTime.now());

        // Add the new message to the chat, save history, and update state
        allMessages.insert(0, m1);
        saveChatHistory();
        setState(() {});
      } else {
        print("Error Occurred");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      // Remove typing indicator
      typing.remove(AI);
      setState(() {});
    }
  }

// Function to delete a message from the chat
  void deleteMessage(ChatMessage message) {
    setState(() {
      allMessages.remove(message);
      saveChatHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          // Handle long press here
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete Message?'),
                content: Text('Do you want to delete this message?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Update messageToDelete with the message to delete
                      setState(() {
                        messageToDelete = messageToDelete;
                      });
                      deleteMessage(
                          messageToDelete); // Perform delete action here
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
        child: DashChat(
          typingUsers: typing,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getdata(m);
          },
          messages: allMessages,
        ),
      ),
    );
  }
}
