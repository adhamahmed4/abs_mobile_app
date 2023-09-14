import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Terms & Conditions',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 244, 246, 248),
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black)),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Welcome to ABS! By using our app, you agree to comply with and be bound by the following terms and conditions. Please read them carefully before using the app.\n\n"
              "Service Description\n\n"
              "ABS provides users with the ability to request package delivery and track shipments. Our app is designed to make shipping and receiving packages convenient and efficient.\n\n"
              "User Responsibilities\n\n"
              "- You must provide accurate and up-to-date information when using the app.\n"
              "- You must not use the app for any illegal or unauthorized purpose.\n"
              "- You must not interfere with the app's functionality or security features.\n\n"
              "Payment\n\n"
              "- Payment for our services can be made through the methods provided in the app.\n"
              "- Any charges associated with our services will be clearly displayed before you confirm your request.\n"
              "Delivery and Shipping\n\n"
              "- We strive to provide accurate delivery estimates, but actual delivery times may vary.\n"
              "- Tracking features are available for most shipments.\n"
              "- Packages must meet our size and weight restrictions and should not contain prohibited items.\n"
              "Privacy and Data Handling\n\n"
              "- We collect and use user data in accordance with our Privacy Policy.\n"
              "- We use cookies and tracking technologies to enhance user experience and gather usage information.\n"
              "Intellectual Property\n\n"
              "- The content, trademarks, and copyrights in the app are owned by ABS.\n"
              "- You may not use our intellectual property without our prior written consent.\n"
              "Liability and Disclaimers\n\n"
              "- We are not liable for any damages or losses arising from your use of the app.\n"
              "- We do not guarantee the accuracy or availability of the information and services provided.\n"
              "Termination\n\n"
              "- We reserve the right to terminate or suspend user accounts for any reason.\n"
              "- You may terminate your account at any time by following the app's instructions.\n"
              "Governing Law\n\n"
              "- These terms and conditions are governed by the laws of [Your Jurisdiction].\n"
              "- Any disputes arising from these terms will be resolved in [Your Jurisdiction].\n"
              "Changes to Terms\n\n"
              "- We may update or modify these terms and conditions from time to time.\n"
              "- Any changes will be communicated to users through the app.\n"
              "Contact Information\n\n"
              "If you have any questions or concerns about these terms and conditions, please contact us at [contact@email.com].",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ));
  }
}
