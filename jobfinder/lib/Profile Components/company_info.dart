// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/ProfilePage.dart';
import 'package:jobfinder/welcome.dart';

// StatefulWidget for Company Information Page
class CompanyInformationPage extends StatefulWidget {
  @override
  _CompanyInformationPageState createState() => _CompanyInformationPageState();
}

// State class for Company Information Page
class _CompanyInformationPageState extends State<CompanyInformationPage> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for various input fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Firebase authentication and Firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase user object
  User? _user;

  // Map to store company details
  Map<String, dynamic> _companydetails = {};

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the widget initializes
  }

  // Fetch user data from Firestore
  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      final userData = await _firestore.collection('admin').doc(user.uid).get();
      if (userData.exists) {
        final userDataMap = userData.data() as Map<String, dynamic>;
        setState(() {
          _companydetails = userDataMap;
        });
      }
    }
  }

  // Function to validate website format
  bool _isValidWebsite(String value) {
    final RegExp websiteRegExp = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
      caseSensitive: false,
      multiLine: false,
    );
    return websiteRegExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar configuration
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Company Information'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 6, 60, 74),
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              await _signOut();
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 134, 160, 166),
      body: SingleChildScrollView(
        // Scrollable body content
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display current user's email
                Text(_auth.currentUser!.email.toString()),
                // Form fields for company information
                TextFormField(
                  controller: _companyNameController,
                  decoration: InputDecoration(labelText: 'company name'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter company name'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number'.tr;
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Phone number must contain only digits'.tr;
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'location'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _websiteController,
                  decoration: InputDecoration(labelText: 'website'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter website'.tr;
                    }
                    if (!_isValidWebsite(value)) {
                      return 'Please enter a valid website'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                // Save button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      primary: Color.fromARGB(255, 6, 60, 74),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveUserDataToFirestore();
                      }
                    },
                    child: Text(
                      'save'.tr,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Done button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      primary: Color.fromARGB(255, 6, 60, 74),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobProfilePage(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'done'.tr,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to sign out the user
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const Welcome();
        },
      ));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Function to save user data to Firestore
  Future<void> _saveUserDataToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userData = {
        'company': _companyNameController.text,
        'email': _auth.currentUser!.email.toString(),
        'contact': _phoneController.text,
        'location': _locationController.text,
        'website': _websiteController.text,
      };
      final docId = currentUser.uid;
      final userRef = FirebaseFirestore.instance.collection('admin').doc(docId);

      await userRef.set(userData);

      _showSuccessMessage();
    }
  }

  // Function to display success message as SnackBar
  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Company information saved successfully.'.tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose text editing controllers
    _companyNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}

// Main function to run the app
void main() {
  runApp(MaterialApp(
    home: CompanyInformationPage(),
  ));
}
