import 'package:flutter/material.dart';
import 'package:healthcare_management_system/screens/appointments.dart';
import 'package:healthcare_management_system/screens/home.dart';
import 'package:healthcare_management_system/screens/messages.dart';
import 'package:healthcare_management_system/screens/symptomsPage.dart';


class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => LayoutState();
}

class LayoutState extends State<Layout> {
  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value){
          setState(() {
            currentPage = value;
          });
        }),
        children: <Widget>[
          Home(),
          SymptomsPage(),
          Appointments(doctor: {},),          
          Messages(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page){
          setState(() {
            currentPage = page;
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sick),
            label: "Symptoms",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),
        ],
      ),
    );
  }
}
