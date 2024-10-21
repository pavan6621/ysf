

// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ysf/const/constdata.dart';

// import '../map/google_map_page.dart';

// class SignUp extends StatefulWidget {
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database =
//       FirebaseDatabase.instance.ref("Personal information");
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _pickupLocationController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   LatLng? selectedCoordinates;
//   bool _obscureText = true;
//   bool isLoading = false;

//   void _signUp() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//     String username = _usernameController.text.trim();
//     String phone = _phoneController.text.trim();
//     String address = _addressController.text.trim();

//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await _database.child('users').child(userCredential.user!.uid).set({
//         'name': username,
//         'email': email,
//         'phone': phone,
//         'address': address,
//         "latitude": selectedCoordinates?.latitude,
//         "longitude": selectedCoordinates?.longitude,
//       });

//       Navigator.pushReplacementNamed(context, navigate_SignIn);
//     } on SocketException catch (_) {
//       showError('Please connect to the internet');
//     } catch (e) {
//       if (e is FirebaseAuthException) {
//         showError('Failed to sign up: ${e.message}');
//       } else {
//         showError('Failed to sign up: $e');
//       }
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _navigateToMap() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GoogleMapPage(),
//       ),
//     );

//     if (result != null && result is LatLng) {
//       setState(() {
//         selectedCoordinates = result;
//       });
//     }
//   }

//   void showError(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: message == 'Please connect to the internet'
//               ? Text('Internet Lost')
//               : Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _toggleVisibility() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }

//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     return null;
//   }

//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }

//   String? validateConfirmPassword(String? value) {
//     if (value != _passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, navigate_SignIn);
//           },
//         ),
//       ),
//       body: isLoading
//           ? Container(
//               child: const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF0E9AFF)),
//               ),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Text(
//                     "Sign Up",
//                     style: GoogleFonts.workSans(
//                       textStyle: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(16.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextFormField(
//                             controller: _usernameController,
//                             decoration: const InputDecoration(
//                               labelText: 'Name',
//                               border: OutlineInputBorder(),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               labelStyle: TextStyle(color: Color(0xFFFCFCFD)),
//                             ),
//                             validator: (value) => value!.isEmpty
//                                 ? 'Please enter your name'
//                                 : null,
//                             style: const TextStyle(color: Color(0xFFF5F1F1)),
//                           ),
//                           SizedBox(height: 8.0),
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: const InputDecoration(
//                               labelText: 'Email',
//                               border: OutlineInputBorder(),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               labelStyle: TextStyle(color: Color(0xFFFCFCFD)),
//                             ),
//                             validator: validateEmail,
//                             style: const TextStyle(color: Color(0xFFF5F1F1)),
//                           ),
//                           SizedBox(height: 8.0),
//                           TextFormField(
//                             controller: _phoneController,
//                             keyboardType:
//                                 TextInputType.phone, 
//                             decoration: const InputDecoration(
//                               labelText: 'Phone Number',
//                               border: OutlineInputBorder(),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               labelStyle: TextStyle(color: Color(0xFFFCFCFD)),
//                             ),
//                             validator: validatenumber,
//                             style: const TextStyle(color: Color(0xFFF5F1F1)),
//                           ),
//                           SizedBox(height: 8.0),
//                           TextFormField(
//                             controller: _addressController,
//                             decoration: const InputDecoration(
//                               labelText: 'Address',
//                               border: OutlineInputBorder(),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               labelStyle: TextStyle(color: Color(0xFFFCFCFD)),
//                             ),
//                             validator: (value) => value!.isEmpty
//                                 ? 'Please enter your address'
//                                 : null,
//                             style: const TextStyle(color: Color(0xFFF5F1F1)),
//                           ),
//                           SizedBox(height: 8.0),
//                           ElevatedButton(
//                             onPressed: _navigateToMap,
//                             child: Text('Pick Location on Map'),
//                           ),
//                           SizedBox(height: 8.0),
//                           TextFormField(
//                             controller: _passwordController,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               border: const OutlineInputBorder(),
//                               focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               labelStyle:
//                                   const TextStyle(color: Color(0xFFF5F1F1)),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscureText
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: _toggleVisibility,
//                               ),
//                             ),
//                             obscureText: _obscureText,
//                             validator: validatePassword,
//                             style: const TextStyle(color: Color(0xFFF5F1F1)),
//                           ),
//                           SizedBox(height: 8.0),
//                           TextFormField(
//                             controller: _confirmPasswordController,
//                             decoration: const InputDecoration(
//                               labelText: 'Confirm Password',
//                               border: OutlineInputBorder(),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.white,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               labelStyle: TextStyle(color: Color(0xFFF5F1F1)),
//                             ),
//                             obscureText: true,
//                             validator: validateConfirmPassword,
//                             style: const TextStyle(color: Color(0xFFF5F1F1)),
//                           ),
//                           SizedBox(height: 16.0),
//                           ElevatedButton(
//                             onPressed: (){if(selectedCoordinates != null){_signUp();}else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please choose your location ')),
//                     );
//                   }},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFF0E9AFF),
//                               minimumSize: Size(double.infinity, 40),
//                             ),
//                             child: Text(
//                               'Sign Up',
//                               style: GoogleFonts.workSans(
//                                 textStyle: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16.0),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ysf/const/constdata.dart';

import '../map/google_map_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref("Personal information");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _address3Controller = TextEditingController();
  final TextEditingController _address4Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LatLng? selectedCoordinates;
  bool _obscureText = true;
  bool isLoading = false;

  void _signUp() async {
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

    setState(() {
      isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String username = _usernameController.text.trim();
    String phone = _phoneController.text.trim();
    String address1 = _address1Controller.text.trim();
    String address2 = _address2Controller.text.trim();
    String address3 = _address3Controller.text.trim();
    String address4 = _address4Controller.text.trim();

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _database.child('users').child(userCredential.user!.uid).set({
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
    } on SocketException catch (_) {
      showError('Please connect to the internet');
    } catch (e) {
      if (e is FirebaseAuthException) {
        showError('Failed to sign up: ${e.message}');
      } else {
        showError('Failed to sign up: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapPage(),
      ),
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

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }



  String? validateConfirmPassword(String? value) {
     if (value == null || value.trim().isEmpty) {
      return 'Please enter Confirm Password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: myColor,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacementNamed(context, navigate_SignIn);
    },
  ),
  title: Text(
    'Sign Up',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  ),
  centerTitle: true,
),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: myColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _usernameController,
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
                            validator: validateUser,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
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
                            validator: validateEmail,
                          ),
                          SizedBox(height: 8),
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
                            validator:validatenumber,
                          ),
                          SizedBox(height: 8),
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
                          ),SizedBox(height: 8),
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
                          ),SizedBox(height: 8),
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
                          ),SizedBox(height: 8),
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
                          ),SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _navigateToMap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:myColor,
                              minimumSize: Size(double.infinity, 48),
                               shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                            ),
                            child: Text(
  selectedCoordinates == null 
    ? 'Pick Location on Map' 
    : 'Pick Location on Map\nLatitude: ${selectedCoordinates!.latitude.toStringAsFixed(4)}, Longitude: ${selectedCoordinates!.longitude.toStringAsFixed(4)}',
  style: TextStyle(color: Colors.black),
),

                          ),SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: _toggleVisibility,
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: validatePassword,
                          ),SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: myColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: validateConfirmPassword,
                          ),SizedBox(height: 8),
                          ElevatedButton(
                            onPressed:  _signUp,
                                
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              minimumSize: Size(double.infinity, 50),
                               shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
}
