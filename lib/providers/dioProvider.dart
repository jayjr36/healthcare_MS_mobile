import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare_management_system/models/patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DioProvider {
  String url = 'http://192.168.100.44:8000';
  //to get token
  Future<dynamic> loginuser(String email, String password) async {
    try {
      var response = await Dio()
          .post('$url/api/login', data: {'email': email, 'password': password});

      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
    }
  }

//to get user data
  Future<dynamic> getUser(String token) async {
    try {
      var user = await Dio().get('$url/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
    } catch (error) {
      return error;
    }
  }

  //to register new user
  Future<bool> registerUser(
      String username, String email, String password) async {
    try {
      var user = await Dio().post(
        '$url/api/register',
        data: {'name': username, 'email': email, 'password': password},
      );

      if (user.statusCode == 200 && user.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Registration error: $error');
      return false;
    }
  }

  //store booking details
  Future<dynamic> bookAppointment(
      String date, String day, String time, int doctor, String token) async {
    try {
      var response = await Dio().post('$url/api/book',
          data: {'date': date, 'day': day, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
  Future<dynamic> getUpcomingAppointments(String token) async {
    try {
      var response = await Dio().get('$url/api/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> getCompletedAppointments(String token) async {
    try {
      var response = await Dio().get('$url/api/appointments/completed',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> getCancelledAppointments(String token) async {
    try {
      var response = await Dio().get('$url/api/appointments/canceled',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return json.encode(response.data);
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //store ratings details
  Future<dynamic> storeReviews(
      String reviews, double ratings, int id, int doctor, String token) async {
    try {
      var response = await Dio().post('$url/api/reviews',
          data: {
            'ratings': ratings,
            'reviews': reviews,
            'appointment_id': id,
            'doctor_id': doctor
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  Future<List<dynamic>> fetchSchedules(String token) async {
    try {
      final response = await Dio().get('$url/api/schedules',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        print(response.data); // Debug print
        return response.data;
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load schedules');
    }
  }

  Future<void> savePatientDetails(Patient patient, String token) async {
    final response = await http.post(
      Uri.parse('$url/store/patient-details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode({
        'first_name': patient.firstName,
        'last_name': patient.lastName,
        'email': patient.email,
        'contact_number': patient.contactNumber,
        'date_of_birth': patient.dateOfBirth,
        'gender': patient.gender,
        'blood_group': patient.bloodGroup,
        'marital_status': patient.maritalStatus,
        'height': patient.height,
        'weight': patient.weight,
      }),
    );

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: 'Profile saved successfully', backgroundColor: Colors.green);
      print('Profile saved successfully');
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to save profile', backgroundColor: Colors.red);
    }
  }

  Future<void> cancelAppointment(int appointmentId, String token) async {
    final apiUrl = "$url/appointments/$appointmentId/cancel";

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            token, 
      },
    );

    if (response.statusCode == 200) {
     
      Fluttertoast.showToast(msg:'Appointment cancelled successfully', backgroundColor: Colors.green);
    } else {
      Fluttertoast.showToast(msg:'Failed to cancel appointment', backgroundColor: Colors.red);
    }
  }
}
