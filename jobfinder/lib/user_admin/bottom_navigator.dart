import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/Jobs/SearchJob.dart';
import 'package:jobfinder/Profile%20Components/AllAPpliedJobs.dart';
import 'package:jobfinder/formsForFirst/userInfoData.dart';
import 'package:jobfinder/user/list_job.dart';
import 'package:jobfinder/user/profile.dart';
// import 'package:jobfinder/user_admin/example.dart';

class Bottom_navigator_User extends StatefulWidget {
  const Bottom_navigator_User({super.key});

  @override
  State<Bottom_navigator_User> createState() => _Bottom_navigator_UserState();
}

class _Bottom_navigator_UserState extends State<Bottom_navigator_User> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
          Icons.work,
          Icons.search,
          Icons.list,
          Icons.person,
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => User_job_list()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobSearchPage()),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => JobsPostedPage(),
              ),
            );
          } else if (index == 3) {
            final user = _auth.currentUser;
            if (user != null) {
              _firestore
                  .collection('userdata')
                  .doc(user.uid)
                  .get()
                  .then((docSnapshot) {
                if (docSnapshot.exists) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => User_profile()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoPage()),
                  );
                }
              });
            }
          }
        });
  }
}
