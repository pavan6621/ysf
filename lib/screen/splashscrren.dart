import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/constdata.dart';
import 'homescreen.dart';
import 'signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    setState(() {
      _username = username;
    });

    if (_username == null) {
    
            await Navigator.pushReplacementNamed(context, navigate_SignIn);
    } else {
           await Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text(""),
      ),
    );
  }
}
