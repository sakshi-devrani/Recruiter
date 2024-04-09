// ignore_for_file: unused_field
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/Components/BottomNavigator.dart'; // Importing necessary packages and files
import 'package:jobfinder/formsForFirst/education.dart';
import 'package:jobfinder/formsForFirst/jobdata.dart';
import 'package:jobfinder/formsForFirst/userInfoData.dart';

class ApplicantProfile extends StatefulWidget {
  final String documentId; // Document ID to identify the user

  ApplicantProfile({required this.documentId}); // Constructor to initialize the document ID

  @override
  _ApplicantProfileState createState() => _ApplicantProfileState();
}

class _ApplicantProfileState extends State<ApplicantProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // Firebase user object
  List<Map<String, dynamic>> _experiences = []; // List to hold user's experiences
  Map<String, dynamic>? _userData; // Map to hold user data
  List<dynamic> _skills = []; // List to hold user's skills
  int _formDone = 0; // Variable to track the completion of user form
  List<Color> skillColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
  ]; // List of colors for skills

  @override
  void initState() {
    super.initState();
    checkform(); // Check the completion status of the form
    _getUserData(); // Get user data from Firestore
  }

  // Method to check form completion status
  Future<void> checkform() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('userdata').doc(widget.documentId).get();

      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('formdone')) {
          setState(() {
            _formDone = userData['formdone']; // Set form completion status
          });
        } else {
          _firestore
              .collection('userdata')
              .doc(widget.documentId)
              .set({'formdone': 5}, SetOptions(merge: true)); // If form status doesn't exist, set it to 5 (indicating all forms are incomplete)

          setState(() {
            _formDone = 5;
          });
        }
      }
    }
  }

  // Method to get user data from Firestore
  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      final userData =
          await _firestore.collection('userdata').doc(widget.documentId).get();
      if (userData.exists) {
        final userDataMap = userData.data() as Map<String, dynamic>;

        final experiencesData = await _firestore
            .collection('userdata')
            .doc(widget.documentId)
            .collection('experiences')
            .get();
        setState(() {
          _experiences = experiencesData.docs
              .map((doc) => doc.data())
              .toList(); // Set user's experiences
        });

        final skills = userDataMap['skills'] as List<dynamic>;
        setState(() {
          _skills = skills; // Set user's skills
        });

        setState(() {
          _userData = userDataMap; // Set user data
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _formDone == 0 // Check form completion status
        ? MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 3, 53, 41),
                title: Text('Job Profile'),
              ),
              backgroundColor: Color.fromARGB(255, 3, 53, 41),
              body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    // Widgets to display user information
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavigatorExample(),
            ),
          )
        : _buildPageForFormDoneValue(_formDone); // Build page based on form completion status
  }

  // Method to build page based on form completion status
  Widget _buildPageForFormDoneValue(int formDone) {
    switch (formDone) {
      case 1:
        return UserInfoPage(); // Build UserInfoPage if formDone is 1
      case 2:
        return AddEducationPage(); // Build AddEducationPage if formDone is 2
      case 3:
        return AddExperiencePage(); // Build AddExperiencePage if formDone is 3
      case 4:
        return Page4(); // Build Page4 if formDone is 4

      default:
        return Text('Invalid formdone value: $formDone'); // Return error message for invalid formDone value
    }
  }
}

// Other Page classes for navigation
class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Center(
        child: Text('This is Page 1'),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Center(
        child: Text('This is Page 2'),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: Center(
        child: Text('This is Page 3'),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 4'),
      ),
      body: Center(
        child: Text('This is Page 4'),
      ),
    );
  }
}
