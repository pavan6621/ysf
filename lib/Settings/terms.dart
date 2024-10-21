import 'package:flutter/material.dart';
import 'package:ysf/const/constdata.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: Text(
          'Terms and Conditions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () {
            Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Terms and Conditions"),
              _sectionSubTitle("Effective Date: [Insert Date]\n"),
              _sectionText(
                "Welcome to Yannis Sustainable Food App. These Terms and Conditions ('Terms') govern your access to and use of our app and services. By using the app, you agree to be bound by these Terms. Please read them carefully.\n",
              ),
              _divider(),
              _sectionTitle("1. Acceptance of Terms"),
              _sectionText(
                "By accessing and using Yannis Sustainable Food App ('the App'), you accept and agree to be bound by these Terms. If you do not agree with these Terms, you may not use the App.",
              ),
              _divider(),
              _sectionTitle("2. Eligibility"),
              _sectionText(
                "You must be at least 18 years of age to use the App. By using the App, you represent that you are of legal age and have the capacity to enter into a binding contract.",
              ),
              _divider(),
              _sectionTitle("3. Use of the App"),
              _sectionText(
                "- The App provides access to sustainable food products and services.\n"
                "- You agree to use the App only for lawful purposes and in accordance with these Terms.\n"
                "- You are responsible for maintaining the confidentiality of your account login information and for all activities that occur under your account.",
              ),
              _divider(),
              _sectionTitle("4. User Accounts"),
              _sectionText(
                "- When you create an account on the App, you must provide accurate, current, and complete information.\n"
                "- You agree to update your information if any changes occur.\n"
                "- You are responsible for maintaining the security of your account and are liable for all activities conducted under your account.",
              ),
              _divider(),
              _sectionTitle("5. Sustainable Food Products"),
              _sectionText(
                "Yannis Sustainable Food App partners with local producers and suppliers to offer organic, sustainably sourced food products. Product availability, prices, and descriptions are subject to change without notice.",
              ),
              _divider(),
              _sectionTitle("6. Ordering and Payment"),
              _sectionText(
                "- You may place orders through the App by selecting available products.\n"
                "- Prices for products will be displayed in the App and may include applicable taxes.\n"
                "- Payment must be made through the App using approved payment methods.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A helper widget to display section titles
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold, // Text color
        ),
      ),
    );
  }

  Widget _sectionSubTitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600, // Subtitle color
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87, // Main text color
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade400,
      thickness: 1,
      height: 32,
    );
  }
}

