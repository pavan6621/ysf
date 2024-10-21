import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../map/google_map_page.dart';
import '../const/constdata.dart';


class PersonalInfo extends StatefulWidget {
  @override
  PersonalInfoState createState() => PersonalInfoState();
}

class PersonalInfoState extends State<PersonalInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("Personal information");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _address3Controller = TextEditingController();
  final TextEditingController _address4Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  LatLng? selectedCoordinates;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getReceiverInfo();
  }
Future<void> _getReceiverInfo() async {
  setState(() {
    isLoading = true;
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');
  var email = prefs.getString('email');
  var username = prefs.getString('username');

  if (userId == null || userId.isEmpty) {
    showError('User ID not found');
    setState(() {
      isLoading = false;
    });
    return;
  }

  try {
    final DatabaseReference userRef = FirebaseDatabase.instance.ref('Personal information/users/$userId');
    DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      Map<dynamic, dynamic>? receiverInfo = event.snapshot.value as Map<dynamic, dynamic>?;

      if (receiverInfo != null) {
        setState(() {
          _emailController.text = receiverInfo['email'] ?? email;
          _usernameController.text = receiverInfo['name'] ?? username;
          _phoneController.text = receiverInfo['phone'] ?? '';
          _address1Controller.text = receiverInfo['address1'] ?? '';
          _address2Controller.text = receiverInfo['address2'] ?? '';
          _address3Controller.text = receiverInfo['address3'] ?? '';
          _address4Controller.text = receiverInfo['address4'] ?? '';
          selectedCoordinates = LatLng(receiverInfo['latitude'] ?? 0.0, receiverInfo['longitude'] ?? 0.0);
        });
      } else {
        showError('No information found for the user.');
      }
    } else {
      _emailController.text =email!;
          _usernameController.text = username!;
    }
  } catch (e) {
    print('Error fetching receiver information: ${e}');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  void save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (selectedCoordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please choose your location'),
        ),
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String phone = _phoneController.text.trim();
    String address1 = _address1Controller.text.trim();
    String address2 = _address2Controller.text.trim();
    String address3 = _address3Controller.text.trim();
    String address4 = _address4Controller.text.trim();

    await _database.child('users').child(userId!).set({
      'name': username,
      'email': email,
      'phone': phone,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'address4': address4,
      "latitude": selectedCoordinates?.latitude,
      "longitude": selectedCoordinates?.longitude,
    });

    Navigator.pushReplacementNamed(context, navigate_SignIn);
  }

  void _navigateToMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoogleMapPage()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedCoordinates = result;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
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
      backgroundColor: Colors.white,
     
      appBar: AppBar(
  backgroundColor: myColor,
  title: Container(
    alignment: Alignment.center,
    child: Text(
      'Personal Information',
      textAlign: TextAlign.center,
    ),
  ),
  centerTitle: true, // This centers the title
),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: myColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            readOnly: true, 
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            readOnly: true, 
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: validatenumber,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _address1Controller,
                            decoration: InputDecoration(
                              labelText: 'Address1',
                              hintText: 'Flat Number',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: validateAddress1,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _address2Controller,
                            decoration: InputDecoration(
                              labelText: 'Address2',
                              hintText: 'Street/colony',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: validateAddress2,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _address3Controller,
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: validateAddress3,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _address4Controller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Pin Code',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: validateAddress4,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _navigateToMap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Text(
  selectedCoordinates == null 
    ? 'Pick Location on Map' 
    : 'Pick Location on Map\nLatitude: ${selectedCoordinates!.latitude.toStringAsFixed(4)}, Longitude: ${selectedCoordinates!.longitude.toStringAsFixed(4)}',


                              style: GoogleFonts.workSans(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: GoogleFonts.workSans(
                                    textStyle: const TextStyle(
                                      color:  Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _address4Controller.dispose();
    super.dispose();
  }
}
