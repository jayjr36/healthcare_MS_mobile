import 'dart:async';

import 'package:flutter/material.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
import 'package:healthcare_management_system/utils/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String? token;
  String url = DioProvider().url;
 

  loadpreference() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }  

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$url/api/users'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

 @override
  void initState() {
    super.initState();
    loadpreference();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Config.primaryColor),
        leading: SizedBox.shrink(),
          backgroundColor: Config.primaryColor,
          title: Text(
            'Contacts',
            style: TextStyle(color: Colors.white),
          )),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(user: users[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Center(
                        child: SizedBox(
                            height: 30,
                            child: Text(users[index].name.toUpperCase()))),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  String? token;
  String url = DioProvider().url;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    loadPreference();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> loadPreference() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
    _fetchMessages();
    _startMessageFetching();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(
          Uri.parse('$url/api/chats/${widget.user.id}'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          _messages = jsonResponse.map((message) => Message.fromJson(message)).toList();
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
    }
  }

  Future<void> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$url/api/chats/send'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'receiver_id': widget.user.id,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      _fetchMessages();
    } else {
      throw Exception('Failed to send message');
    }
  }

  void _startMessageFetching() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = widget.user.id;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: Text(
          '${widget.user.name}'.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _messages.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isCurrentUser = message.receiverId == currentUserId;
                      return Row(
                        mainAxisAlignment: isCurrentUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: isCurrentUser ? Colors.green[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message.message,
                              style: TextStyle(
                                color: isCurrentUser ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
    );
  }
}
