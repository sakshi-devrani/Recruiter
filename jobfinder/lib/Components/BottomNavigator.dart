import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/Jobs/PostAJob.dart';
import 'package:jobfinder/Jobs/SeeAllJobPostedByCurrentUser.dart';
import 'package:jobfinder/Jobs/home_posted.dart';
import 'package:jobfinder/Profile%20Components/ProfilePage.dart';
import 'package:jobfinder/Profile%20Components/company_info.dart';


class BottomNavigatorExample extends StatefulWidget {
  @override
  _BottomNavigatorExampleState createState() => _BottomNavigatorExampleState();
}
class _BottomNavigatorExampleState extends State<BottomNavigatorExample> {
  // int _currentIndex = 0;
  // PageController _pageController = PageControlle: 0);
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String documentId = "";
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      borderColor: Color.fromARGB(255, 85, 143, 151),
      gapWidth: 0,
      activeColor: Color.fromARGB(255, 85, 143, 151),
      activeIndex: _currentIndex,
      inactiveColor: Color.fromARGB(255, 85, 143, 151),
      backgroundColor: Colors.white,
      icons: [
        Icons.home,
        Icons.format_list_bulleted_rounded,
        Icons.add_box,
        Icons.person,
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home_postedjob()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SeeAllooJobPostedPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobPostingPage()),
          );
        } else if (index == 3) {
          final user = _auth.currentUser;
          if (user != null) {
            _firestore
                .collection('admin')
                .doc(user.uid)
                .get()
                .then((docSnapshot) {
              if (docSnapshot.exists) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JobProfilePage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanyInformationPage()),
                );
              }
            });
          }
        }
      },
    );
  }
}
