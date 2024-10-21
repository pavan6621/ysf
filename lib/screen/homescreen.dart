

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/constdata.dart';
import '../pages/mydonations.dart';
import '../pages/receiver.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = ConstData.indexpage;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return MyDonations();
      case 1:
        return Receiver();
      default:
        return MyDonations();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      ConstData.indexpage = index;
    });
  }



  Future<void> _signOut() async {
    
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _auth.signOut();
        await _googleSignIn.signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('username');
        setState(() {
      ConstData.indexpage = 0;
    });
        Navigator.pushReplacementNamed(context, navigate_SignIn);
      }
    } on SocketException catch (_) {
      print('Please connect to the internet');
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Failed to sign out: ${e.code}');
      } else {
        print('Failed to sign out: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _selectedIndex, 
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: myColor,
  title: Container(
    alignment: Alignment.center,
    child: Text(
      'Home',
      textAlign: TextAlign.center,
    ),
  ),
  centerTitle: true,
          bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              onTap: _onItemTapped,
              tabs: [
                 _buildTab('Donor', 'lib/assets/donate.svg'),
                _buildTab('Receiver', 'lib/assets/receive.svg'),
               
              ],
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              labelStyle: GoogleFonts.openSans(fontSize: 16),
            ),
          ),
        ),
        ),
        body: TabBarView(
        children: [
          
          MyDonations(),
          Receiver(),
        ],
      ),
      ),
    );
  }

  Widget _buildTab(String label, String iconPath) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
