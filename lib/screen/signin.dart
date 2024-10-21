// import 'dart:async';
// import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../const/constdata.dart';

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   _SignInState createState() => _SignInState();
// }

//   class _SignInState extends State<SignIn> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   String? _messageTitle;
//   String? _messageBody;

//   bool _obscureText = true;
//   bool isLoading = false;
//  var tokenfcm;
//  var _username;


 
//   @override
//   void initState() {
//     super.initState();
//     _connectivitySubscription = Connectivity()
//         .onConnectivityChanged
//         .listen((List<ConnectivityResult> result) {
//       if (result.isEmpty || result.contains(ConnectivityResult.none)) {
//         _showNoInternetPopup();
//       }
//     });
//     fetchData();
//   }

//   void _showNoInternetPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('No Internet Connection'),
//           content: Text('Please check your internet settings.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
  
//   Future<void> fetchData() async {

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var username = prefs.getString('username');
//     if (username != null) {
     

//         await Navigator.pushReplacementNamed(context, navigate_Home);
      
//     }
//   }
//  void _signIn() async {
//   if (!_formKey.currentState!.validate()) {
//     return;
//   }
//   setState(() {
//     isLoading = true;
//   });

//   String email = _emailController.text.trim();
//   String password = _passwordController.text.trim();

//   try {
//     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     User? user = _auth.currentUser;

//     if (user != null) {
//       String userId = user.uid;
//       String? username = user.displayName;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       // await prefs.setString('username', Globals.name);
//       await prefs.setString('userId', userId);
//        Navigator.pushReplacementNamed(context, navigate_Home);
//     }
//   } on SocketException catch (_) {
//     showError('Please connect to the internet');
//   } catch (e) {
//     if (e is FirebaseAuthException) {
//       showError('Failed to sign in: ${e.code}');
//     } else {
//       showError('Failed to sign in: $e');
//     }
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }





//  Future<void> _signInWithGoogle() async {
//   setState(() {
//     isLoading = true;
//   });


//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       return;
//     }
//     String email = googleUser.email;
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     await _auth.signInWithCredential(credential);

//     User? user = _auth.currentUser;
//     String uid = user?.uid ?? 'No UID';
//     setState(() {
//       _username = user?.displayName ?? 'No User Name';
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('username', _username!);
//     await prefs.setString('email', email);
//     await prefs.setString('userId', uid);  


//     await Navigator.pushReplacementNamed(context, navigate_Home);
//   } on SocketException catch (_) {
//     showError('Please connect to the internet');
//   } catch (e) {
//     if (e is FirebaseAuthException) {
//       showError('Failed to sign in: ${e.code}');
//     } else {
//       showError('Failed to sign in: $e');
//     }
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
//  }






//   void showError(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: "Please connect to the internet" == message ?Text('Internet Lost'):Text('Error'),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  isLoading
//           ? Container( child:const Center(child: CircularProgressIndicator(color: Color(0xFF0E9AFF),)))
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
             
//               Text(
//                 "Sign In",
//                 style: GoogleFonts.workSans(
//                   textStyle: const TextStyle(color: Colors.white,fontSize: 20,),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                   width: 500,
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ListTile(
//                       title:    TextFormField(
//                             controller: _emailController,
//                             decoration: const InputDecoration(
//                               labelText: 'Email',
//                               border: OutlineInputBorder(),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Color.fromARGB(255, 255, 255, 255),
//                                     width: 2.0),
//                               ),
//                               labelStyle: TextStyle(
//                                   color: Color.fromARGB(255, 252, 252, 253)),
//                             ),
//                             validator: validateEmail,
//                             style: const TextStyle(
//                               color: Color.fromARGB(255, 245, 241,
//                                   241), 
//                             ),
//                           ),
//                         ),
//                        ListTile(
//                       title:    TextFormField(
//                             controller: _passwordController,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               border: const OutlineInputBorder(),
//                               focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Color.fromARGB(255, 249, 250, 250),
//                                     width: 2.0),
//                               ),
//                               labelStyle: const TextStyle(
//                                   color: Color.fromARGB(255, 245, 241, 241)),
//                               suffixIcon: IconButton(
//                                 icon: Icon( 
//                                   _obscureText
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                   color: const Color.fromARGB(255, 251, 252, 252),
//                                 ),
//                                 onPressed: _toggleVisibility,
//                               ),
//                             ),
//                             obscureText: _obscureText,
//                             validator: validatePassword,style: const TextStyle(
//                               color: Color.fromARGB(255, 245, 241,
//                                   241),
//                             ),
//                           ),
//                         ),

//                        Center(
//                           child:ListTile(
//                               title:   ElevatedButton(
//                                      onPressed: _signIn,
//                                       style: ElevatedButton.styleFrom(
                                        
//                                         backgroundColor: const Color(0xFF0E9AFF),
//                                         shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
//                                       ),
//                                       child: Text(
//                                        'Sign In',
//                                         style: GoogleFonts.workSans(
//                                           textStyle: const TextStyle(color: Colors.white, fontSize: 16),
//                                         ),
//                                       ),
//                                     ),
//                           ),
//                         ),
//                        const SizedBox(height: 7.0),
//                            Center(
//                           child:TextButton(
//                                      onPressed: (){Navigator.pushReplacementNamed(context, navigate_SignUp);},
//                                       child: Text('Sign Up',
//                                         style: GoogleFonts.workSans( textStyle:const TextStyle(color: Color(0xFF85CCFF), fontSize: 16),
//                                         ),
//                                       ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),



//                 ),    

//                 const SizedBox(height: 15,) ,  
//                 Text("Don't have an account! Login with Google",
//                             style: GoogleFonts.workSans(
//                               textStyle: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ),
//                             ),),  
//                             const SizedBox(height: 15,) , 
//                             IconButton(onPressed: _signInWithGoogle, icon:  Image.asset(
//                             "lib/assets/google-button.png",
//                             width: 78,
//                             height: 78,
//                           ),)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//  }




import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/constdata.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final DatabaseReference _database =
      FirebaseDatabase.instance.ref("Personal information");
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool _obscureText = true;
  bool isLoading = false;
  var tokenfcm;
  var _username;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        _showNoInternetPopup();
      }
    });
    fetchData();
  }

  void _showNoInternetPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    if (username != null) {
      await Navigator.pushReplacementNamed(context, navigate_Home);
    }
  }

  void _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
      }
    } on SocketException catch (_) {
      showError('Please connect to the internet');
    } catch (e) {
      if (e is FirebaseAuthException) {
        showError('Failed to sign in: ${e.code}');
      } else {
        showError('Failed to sign in: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      String email = googleUser.email;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      User? user = _auth.currentUser;
      String uid = user?.uid ?? 'No UID';
      setState(() {
        _username = user?.displayName ?? 'No User Name';
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _username!);
      await prefs.setString('email', email);
      await prefs.setString('userId', uid);
       
      await Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
    } on SocketException catch (_) {
      showError('Please connect to the internet');
    } catch (e) {
      if (e is FirebaseAuthException) {
        showError('Failed to sign in: ${e.code}');
      } else {
        showError('Failed to sign in: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  

  void showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0E9AFF),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Text(
                      "Sign In",
                      style: GoogleFonts.workSans(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 400, 
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity, 
                              child: TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                validator: validateEmail,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity, // Full width TextFormField
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.black54,
                                    ),
                                    onPressed: _toggleVisibility,
                                  ),
                                ),
                                obscureText: _obscureText,
                                validator: validatePassword,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity, // Full width button
                              child: ElevatedButton(
                                onPressed: _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.workSans(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, navigate_SignUp);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.workSans(
                                    textStyle: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Or sign in with Google",
                      style: GoogleFonts.workSans(
                        textStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: _signInWithGoogle,
                      icon: Image.asset(
                        "lib/assets/google-button.png",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
