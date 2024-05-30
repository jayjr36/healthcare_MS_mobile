import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
import 'package:healthcare_management_system/utils/config.dart';
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
    loadPreferences();
  }

  loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      fetchAndSetSchedules(token);
    }
  }

  fetchAndSetSchedules(String token) async {
    try {
      List fetchedSchedules = await dioProvider.fetchSchedules(token);
      setState(() {
        schedules = fetchedSchedules;
      });
    } catch (e) {
      print('Error fetching schedules: $e');
      // Optionally show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: Text('Doctor Schedules', style: TextStyle(color: Colors.white),),
      ),
      body: schedules.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                var schedule = schedules[index];
                return Card(
                  shadowColor: Colors.red,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          schedule['doctor']['profile_photo_url']),
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
