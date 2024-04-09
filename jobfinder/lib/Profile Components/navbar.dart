import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/Privacy_Policy.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/SavedJob.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/feedback.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/intervirew_tips.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/settings.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/share.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/request_page.dart';

class NavBar extends StatefulWidget {
  final uname;
  final email;
  const NavBar({required this.uname, required this.email});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? uid;
  File? _image;
  String? jobId;

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String?> fetchJobId() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('saved_jobs_data')
          .doc(jobId)
          .get();
      if (snapshot.exists) {
        return snapshot.id; // Return the document ID as the job ID
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching job ID: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.uname,
            ),
            accountEmail: Text(
              '${user?.email ?? 'N/A'}',

              // usr!.email! ??
              // 'N/A'
            ),

            currentAccountPicture: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: _image != null
                  ? CircleAvatar(
                      radius: 56, backgroundImage: FileImage(_image!))
                  : const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
            ),
            
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/images/nav.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('saved job'.tr),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return SavedJob();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('share'.tr),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return SharePage();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('request'.tr),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return RequestPage();
                },
              ));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('settings'.tr),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Setting_page();
                  },
                ));
              }),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('feedback'.tr),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return FeedbackPage();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('policies'.tr),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Privacy_Policy();
              },
            )),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.tips_and_updates),
            title: Text('interview tips'.tr),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return InterviewTipsCarousel();
                },
              ));
            },
          ),
          Divider(),
          ListTile(
            title: Text('exit'.tr),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}


