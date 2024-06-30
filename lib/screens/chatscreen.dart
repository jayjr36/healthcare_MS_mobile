// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatScreen extends StatefulWidget {
//   final int chatId;
//   final String doctorName;
//   final String specialization;

//   ChatScreen({required this.chatId, required this.doctorName, required this.specialization});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   List _messages = [];
//   Dio _dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';

//     final response = await _dio.get(
//       'http://your-laravel-api-url/api/chats/${widget.chatId}/messages',
//       options: Options(headers: {'Authorization': 'Bearer $token'}),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         _messages = response.data;
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';

//     final response = await _dio.post(
//       'http://your-laravel-api-url/api/chats/${widget.chatId}/messages',
//       data: {'message': _messageController.text},
//       options: Options(headers: {'Authorization': 'Bearer $token'}),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         _messages.add(response.data);
//         _messageController.clear();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.doctorName),
//             Text(widget.specialization, style: TextStyle(fontSize: 14)),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 var message = _messages[index];
//                 return ListTile(
//                   title: Text(message['user']['name']),
//                   subtitle: Text(message['message']),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(hintText: 'Enter your message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// // import 'package:flutter/material.dart';
// // import 'chat_screen.dart';  // Import the chat screen

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Doctor-Patient Chat',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: HomeScreen(),  // Replace with your home screen
// //       routes: {
// //         '/chat': (context) => ChatScreen(
// //               chatId: ModalRoute.of(context)!.settings.arguments as int,
// //               doctorName: '',  // Pass the actual doctor name
// //               specialization: '',  // Pass the actual specialization
// //             ),
// //       },
// //     );
// //   }
// // }
