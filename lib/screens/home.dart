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
import 'package:shared_preferences/shared_preferences.dart';
import '../components/customAppbar.dart';
import '../components/doctorCard.dart';
import '../utils/config.dart';

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

  @override
  void initState() {
  
    super.initState();
      getData();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: "Meet Your Doctor",
        
      ),
      drawer: AppDrawer(
        userName: "Name",
        //user['name'],
        profilePictureUrl: 'Assets/profile1.jpg',
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetails(),
            ),
          );
        },
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
