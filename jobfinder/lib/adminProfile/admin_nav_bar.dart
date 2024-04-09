// ignore_for_file: unused_field

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/Privacy_Policy.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/feedback.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/settings.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/share.dart';

class Admin_NavBar extends StatefulWidget {
  final uname;
  final email;
  const Admin_NavBar({required this.uname, required this.email});
  @override
  State<Admin_NavBar> createState() => _Admin_NavBarState();
}
class _Admin_NavBarState extends State<Admin_NavBar> {
  String? uid;
  Map<String, dynamic>? _userData;
  File? _image;
  String? jobId;
  User? user = FirebaseAuth.instance.currentUser;
  // Initialize state
  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Account Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.uname,
            ),
            accountEmail: Text(widget.email.toString()),
            // Profile Picture
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
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/nav.jpg')),
            ),
          ),
          // Drawer Items
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
