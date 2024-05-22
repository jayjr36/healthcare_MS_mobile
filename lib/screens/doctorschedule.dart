import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoctorScheduleScreen extends StatefulWidget {
  @override
  _DoctorScheduleScreenState createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  List schedules = [];

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://your-laravel-api-url/api/doctor/schedules'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        schedules = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load schedules');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedules'),
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
                          'http://your-laravel-api-url${schedule['doctor']['profile_photo_url']}'),
                    ),
                    title: Text('Dr. ${schedule['doctor']['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Specialization: ${schedule['doctor']['specialization']}'),
                        Text('Date: ${schedule['date']}'),
                        Text('Time: ${schedule['start_time']} - ${schedule['end_time']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
