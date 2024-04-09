import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/ProfilePage.dart';
import 'package:jobfinder/Profile%20Components/company_info.dart';
import 'package:jobfinder/formsForFirst/userInfoData.dart';
import 'package:jobfinder/user/profile.dart';

class User_admin extends StatefulWidget {
  const User_admin({Key? key}) : super(key: key);

  @override
  State<User_admin> createState() => _User_adminState();
}

class _User_adminState extends State<User_admin> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firebase Firestore instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1000,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              spreadRadius: 10,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(
                "https://media.istockphoto.com/id/665585020/photo/beautiful-girl-texting-on-the-street.jpg?s=612x612&w=0&k=20&c=WAh3M95EVyBZpRAT5Y82WkKgPiRey5E8-JDq6k87aZU="),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
            SizedBox(height: 220),
            Center(
              child: Text(
                "Welcome to the world of".tr, // Translation key for 'Welcome to the world of'
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "TELENTS AND JOBS".tr, // Translation key for 'TELENTS AND JOBS'
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              "at your fingertips".tr, // Translation key for 'at your fingertips'
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  User? userid = FirebaseAuth.instance.currentUser;

                  await FirebaseFirestore.instance
                      .collection('userdata')
                      .doc(userid!.uid)
                      .update({
                    'uid': userid.uid,
                    'usertype': "user",
                  });
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userid.uid)
                      .update({
                    'uid': userid.uid,
                    'usertype': "user",
                  }).then((value) => {});
                } catch (e) {}

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
              },
              child: Container(
                height: 70,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Icon(
                      Icons.business_center_sharp,
                      color: Color.fromARGB(255, 12, 87, 109),
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "find a job".tr, // Translation key for 'find a job'
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 12, 87, 109)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  User? userid = FirebaseAuth.instance.currentUser;

                  await FirebaseFirestore.instance
                      .collection('userdata')
                      .doc(userid!.uid)
                      .update({
                    'uid': userid.uid,
                    'usertype': "admin",
                  });
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userid.uid)
                      .update({
                    'uid': userid.uid,
                    'usertype': "admin",
                  }).then((value) => {});
                } catch (e) {}
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
              },
              child: Container(
                height: 70,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Icon(
                      Icons.people,
                      color: Color.fromARGB(255, 12, 87, 109),
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Hire Candidates".tr, // Translation key for 'Hire Candidates'
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 12, 87, 109)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
