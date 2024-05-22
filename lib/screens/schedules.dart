import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DioProvider dioProvider = DioProvider();
  List schedules = [];

  @override 
  void initState() {
    super.initState();
    dioProvider.fetchSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Schedules'),
      ),
      body: schedules.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                var schedule = schedules[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://th.bing.com/th/id/OIP.bGWeq5kiCoCZU6qEPOb2zgHaIk?rs=1&pid=ImgDetMain'),
                    ),
                    title: Text('Dr. ${schedule['doctor']['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Specialization: ${schedule['doctor']['specialization']}'),
                        Text('Date: ${schedule['date']}'),
                        Text(
                            'Time: ${schedule['start_time']} - ${schedule['end_time']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}