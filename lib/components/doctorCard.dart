import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.route,
    required this.doctor,
  }) : super(key: key);

  final String route;
  final Map<String, dynamic> doctor;


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    final int doctorId =
        doctor['doctor_id']; // Assuming doctor ID is passed in the doctor map

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: h*0.25,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.28,
                child: Image.network(
                  "https://th.bing.com/th/id/OIP.2hAVCZRMcBjsE8AGQfWCVQHaHa?rs=1&pid=ImgDetMain",
                  fit: BoxFit.contain,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dr. ${doctor['doctor_name']}".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    //  const Spacer(),
                      Text(
                        "${doctor['category'].toString().toUpperCase()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Status: ${doctor['status'].toString().toUpperCase()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
                      ),
                      //const Spacer(),
                       Text(
                        "Experience: ${doctor['experience'].toString().toUpperCase()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                        Text(
                        "Doctor Id: ${doctor['doctor_id'].toString().toUpperCase()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(route, arguments: doctor);
        },
      ),
    );
  }
}
