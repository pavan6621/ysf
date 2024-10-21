import 'package:flutter/material.dart';
import 'package:ysf/const/constdata.dart';
import 'package:ysf/screen/homescreen.dart';
import 'package:ysf/screen/personalinfo.dart';
import 'package:ysf/screen/settingsscreen.dart';

class Bottomnavigation extends StatefulWidget {
  @override
  BottomnavigationState createState() => BottomnavigationState();
}

class BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = ConstData.bottomindexpage;

  // List of widgets to display for each tab
  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    PersonalInfo(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      ConstData.bottomindexpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: myColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
