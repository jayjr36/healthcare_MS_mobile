// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:healthcare_management_system/providers/dioProvider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class UsersScreen extends StatefulWidget {
//   @override
//   State<UsersScreen> createState() => _UsersScreenState();
// }

// class _UsersScreenState extends State<UsersScreen> {
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     loadpreferences();
//   }

//   loadpreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       token = prefs.getString('token');
//     });
//   }

//   Future<List<User>> fetchUsers() async {
//     String chaturl = DioProvider().url;
//     final response = await http.get(Uri.parse('$chaturl/api/users'),
//         headers: {'Authorization': 'Bearer $token'});
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((user) => User.fromJson(user)).toList();
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Users')),
//       body: FutureBuilder<List<User>>(
//         future: fetchUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final users = snapshot.data!;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(users[index].name),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatScreen(user: users[index]),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   final User user;

//   ChatScreen({required this.user});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     loadpreference();
//   }

//   loadpreference() async {
//     final pref = await SharedPreferences.getInstance();
//     setState(() {
//       token = pref.getString('token');
//     });
//   }

//   Future<List<Message>> fetchMessages() async {
//     String chaturl = DioProvider().url;
//     final response = await http.get(
//         Uri.parse('$chaturl/api/chats/${widget.user.id}'),
//         headers: {'Authorization': 'Bearer $token'});
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((message) => Message.fromJson(message)).toList();
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat with ${widget.user.name}')),
//       body: FutureBuilder<List<Message>>(
//         future: fetchMessages(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final messages = snapshot.data!;
//             return ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(messages[index].message),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class User {
//   final int id;
//   final String name;

//   User({required this.id, required this.name});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }

// class Message {
//   final int id;
//   final int senderId;
//   final int receiverId;
//   final String message;

//   Message({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'],
//       senderId: json['sender_id'],
//       receiverId: json['receiver_id'],
//       message: json['message'],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
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
  @override
  void initState() {
    super.initState();
    loadpreference();
  }

  loadpreference() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$url/api/users')
    ,headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
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
                return ListTile(
                  title: Text(users[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(user: users[index]),
                      ),
                    );
                  },
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
 late Future<List<Message>> _messages;

  @override
  void initState() {
    super.initState();
    loadpreference();
    _messages = fetchMessages();
    _startMessageFetching();
  }

  String? token;
  String url = DioProvider().url;

  loadpreference() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }

  Future<List<Message>> fetchMessages() async {
    final response = await http.get(
        Uri.parse('$url/api/chats/${widget.user.id}'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Failed to load messages');
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
      setState(() {
        _messages = fetchMessages();
      });
    } else {
      throw Exception('Failed to send message');
    }
  }

  void _startMessageFetching() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _messages = fetchMessages();
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.user.name}')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: _messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].message),
                      );
                    },
                  );
                }
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
