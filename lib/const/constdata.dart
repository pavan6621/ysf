
import 'package:flutter/material.dart';

const String navigate_SignIn ="/SignIn";
const String navigate_SignUp ="/SignUp";
const String navigate_Home ="/Home";
const String navigate_Donor ="/Donor";
const String navigate_Receiver ="/Receiver";
const String navigate_MyDonations ="/MyDonations";
const String navigate_PersonalInfo ="/personalInfo";
const String navigate_Bottomnavigation ="/Bottomnavigation";
const String navigate_ContactUs ="/ContactUs";
const String navigate_Terms ="/Terms";
const String navigate_FAQ ="/FAQ";

const Color myColor = Color(0xFFFF9800);
const Color white = Colors.white;



  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Password';
    }
    if (value.length < 6) {
      return 'Password should be atleast 6 digits';
    }
    return null;
  }
  String? validatenumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Phone Number';
    }
    if (value.length == 10) {
       return null;
    }
    else {
        return 'Please enter valid phone number';
    }
   
  }

  String? validateUser(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Name';
    }
 return null;
  }
  

  String? validateAddress1(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Address1(Flat Number)';
    }
 return null;
  }
    String? validateAddress2(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Address2(Street/Colony)';
    }
 return null;
  }
    String? validateAddress3(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Address3(City)';
    }
 return null;
  }
    String? validateAddress4(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Address4(Pincode)';
    }
 return null;
  }

    String? validateDonate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter what you want to donate';
    }
 return null;
  }


class ConstData {

  static int indexpage = 0;
  static int bottomindexpage = 0;


}