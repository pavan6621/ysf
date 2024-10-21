import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const/constdata.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void deleteUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.delete();
        await _auth.signOut();
        await _googleSignIn.signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('username');
        setState(() {
          ConstData.indexpage = 0;
          ConstData.bottomindexpage = 0;
        });
        Navigator.pushReplacementNamed(context, navigate_SignIn);
      } else {
        showError("No user is currently logged in.");
      }
    } on SocketException catch (_) {
      showError('Please connect to the internet');
    } catch (e) {
      if (e is FirebaseAuthException) {
        showError('Failed to delete account: ${e.code}');
      } else {
        showError('Failed to delete account: $e');
      }
    }
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
          ConstData.bottomindexpage = 0;
        });
        Navigator.pushReplacementNamed(context, navigate_SignIn);
      }
    } on SocketException catch (_) {
      showError('Please connect to the internet');
    } catch (e) {
      if (e is FirebaseAuthException) {
        showError('Failed to sign out: ${e.code}');
      } else {
        showError('Failed to sign out: $e');
      }
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: message == 'Please connect to the internet' ? Text('Internet Lost') : Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Settings',
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SettingsButton(
              text: 'Contact Us',
              icon: Icons.contact_mail,
              onPressed: () {
                Navigator.pushReplacementNamed(context, navigate_ContactUs);
              },
            ),
            Divider(), 
            SettingsButton(
              text: 'FAQ',
              icon: Icons.help,
              onPressed: () {
                Navigator.pushReplacementNamed(context, navigate_FAQ);
              },
            ),
            Divider(),
            SettingsButton(
              text: 'Terms and Conditions',
              icon: Icons.article,
              onPressed: () {
                Navigator.pushReplacementNamed(context, navigate_Terms);
              },
            ),
            Divider(),
            SettingsButton(
              text: 'Delete Account',
              icon: Icons.person,
              onPressed: () {
                deleteUser();
              },
            ),
            Divider(),
           SettingsButton(
  text: 'Logout',
  icon: Icons.logout,
  onPressed: () {
    _signOut();
  },
),

          ],
        ),
      ),
    );
  }
}

class Bottomnavigation extends StatefulWidget {
  @override
  BottomnavigationState createState() => BottomnavigationState();
}

class BottomnavigationState extends State<Bottomnavigation> {
  int _currentIndex = 0;
  List<Widget> _screens = [Screen1(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  SettingsButton({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(text),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.0), 
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Screen'));
  }
}
