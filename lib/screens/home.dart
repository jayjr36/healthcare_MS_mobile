import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare_management_system/components/appDrawer.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
import 'package:healthcare_management_system/screens/appointments.dart';
import 'package:healthcare_management_system/screens/chats.dart';
import 'package:healthcare_management_system/screens/messages.dart';
import 'package:healthcare_management_system/screens/schedules.dart';
import 'package:healthcare_management_system/screens/settings.dart';
import 'package:healthcare_management_system/screens/symptomsPage.dart';
import 'package:healthcare_management_system/screens/userDetails.dart';
import 'package:healthcare_management_system/screens/video/video2.dart';
import 'package:healthcare_management_system/screens/video/videoscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/customAppbar.dart';
import '../components/doctorCard.dart';
import '../utils/config.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentPage = 0;
  List<String> bannerImages = [
    'Assets/banner/1.jpg',
    'Assets/banner/2.jpg',
    'Assets/banner/3.jpg',
  ];

  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty && token != '') {
      final response = await DioProvider().getUser(token);
      if (response != null) {
        setState(() {
          user = json.decode(response);
          print(user);
        });
      }
    }
  }

  Future<List<dynamic>> fetchReviews() async {
    final String apiUrl = 'http://64.23.247.79:8015/api/all/reviews';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception('Failed to load reviews');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    Config().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: "Meet Your Doctor",
      ),
      drawer: AppDrawer(
        userName: "Name",
        //user['name'],
        profilePictureUrl: 'Assets/profile1.jpg',
        // onProfilePressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => UserDetails(),
        //     ),
        //   );
        // },
        onAppointmentPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Appointments(
                doctor: {},
              ),
            ),
          );
        },
        onSymptomsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleScreen(),
            ),
          );
        },
        onNotificationsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Messages(),
            ),
          );
        },
        onSettingsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Settings(),
            ),
          );
        },
        onLogoutPressed: () {},
      ),
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: PageView.builder(
                          itemCount: bannerImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.asset(
                              bannerImages[index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bannerImages.length,
                          (index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Config.primaryColor
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            );
                          },
                        ),
                      ),
                      Config.spaceMedium,
                      // ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: ((context) => VideoCal())));
                      //     },
                      //     child: Text('Video Call')),
                      Text('What our patients say', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                      FutureBuilder<List<dynamic>>(
                        future: fetchReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final reviews = snapshot.data!;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    List.generate(reviews.length, (index) {
                                  final review = reviews[index];
                                  return Container(
                                    width: w*0.8,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Dr ${review['doctor_name']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text('${review['patient_name']}'),
                                        Text('${review['reviews']}'),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            );
                          } else {
                            return const Text('No reviews available');
                          }
                        },
                      ),
                      Config.spaceMedium,
                      Text(
                        "Choose Your Doctor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: List.generate(user['doctor'].length, (index) {
                          return DoctorCard(
                            route: 'doctor',
                            doctor: user['doctor'][index],
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
