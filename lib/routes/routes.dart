import 'package:flutter/material.dart';
import 'package:ysf/Settings/contactus.dart';
import 'package:ysf/screen/personalinfo.dart';
import 'package:ysf/screen/splashscrren.dart';

import '../Settings/faq.dart';
import '../Settings/terms.dart';
import '../pages/donor.dart';
import '../pages/mydonations.dart';
import '../pages/receiver.dart';
import '../screen/bottomnavigation.dart';
import '../screen/homescreen.dart';
import '../screen/signin.dart';
import '../screen/signup.dart';

  class Routes extends StatefulWidget {
  @override
  RoutesState createState() => RoutesState();
}                          
                                          
class RoutesState extends State<Routes> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Casnet',
     theme: ThemeData.light(),
      initialRoute: "/",
   
      routes: {
        
        '/': (context) => SplashScreen(),
        '/SignIn': (context) => SignIn(),
        '/SignUp': (context) => SignUp(),
        '/Home': (context) => Home(),
        '/Donor': (context) => Donor(),
        '/Receiver': (context) => Receiver(),
        '/MyDonations': (context) => MyDonations(),
        '/personalInfo': (context) => PersonalInfo(),
        '/Bottomnavigation': (context) => Bottomnavigation(),
        '/ContactUs': (context) => ContactUs(),
        '/Terms': (context) => Terms(),
        '/FAQ': (context) => FAQ(),

        
      },
    );
  }
}
