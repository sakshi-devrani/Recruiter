// ignore_for_file: unused_field, unused_element, deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/Logine.dart';
import 'package:jobfinder/Profile%20Components/navbar.dart';
import 'package:jobfinder/UpdateProfile/EditExperience.dart';
import 'package:jobfinder/UpdateProfile/UpdateEducation.dart';
import 'package:jobfinder/UpdateProfile/updateinformation.dart';
import 'package:jobfinder/UpdateProfile/updateskills.dart';
import 'package:jobfinder/formsForFirst/education.dart';
import 'package:jobfinder/formsForFirst/userInfoData.dart';
import 'package:jobfinder/user_admin/bottom_navigator.dart';
import 'package:jobfinder/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class User_profile extends StatefulWidget {
  const User_profile({super.key});
  @override
  State<User_profile> createState() => _User_profileState();
}
class _User_profileState extends State<User_profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<Map<String, dynamic>> _experiences = [];
  List<Map<String, dynamic>> _education = [];
  Map<String, dynamic> _userInfo = {};
  List<Map<String, dynamic>> _applicant = [];
  File? _file;
  late SharedPreferences _prefs;
  Map<String, dynamic> address = {};
  List<dynamic> _skills = [];
  int _formDone = 0;
  String certificateName = '';
  String organization = '';
  String issuedYear = '';
  late List<int> years;
  late int selectedYear;
  List<Map<String, dynamic>> certificates = [];
  File? _pickedFile;
  @override
  void initState() {
    super.initState();
    checkform();
    _getUserData();
    _initPrefs();
  }

  String? _selectedPdfPath;

  File? _image;
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final filePath = _prefs.getString('file_path');
    if (filePath != null) {
      setState(() {
        _file = File(filePath);
      });
    }
  }

  bool hasCertificates = false;
// Function to toggle the existence of certificates
  void toggleCertificates(bool value) {
    setState(() {
      hasCertificates = value;
    });
  }

  Future<void> _saveFilePath(String? filePath) async {
    await _prefs.setString('file_path', filePath ?? '');
  }

  void addCertificate(String certificateName, String organization,
      String issuedYear, File? file) {
    certificates.add({
      'certificateName': certificateName,
      'organization': organization,
      'issuedYear': issuedYear,
      'file': file,
    });
  }

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

  Future<void> checkform() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('userdata')
          .doc(_user!.uid) // Use the current user's UID as the document ID
          .get();

      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('formdone')) {
          // If 'formdone' field is present, set its value
          setState(() {
            _formDone = userData['formdone'];
          });
        } else {
          // If 'formdone' field is not present, set it to 5
          _firestore
              .collection('userdata')
              .doc(_user!.uid)
              .set({'formdone': 3}, SetOptions(merge: true));

          setState(() {
            _formDone = 3;
          });
        }
      }
    }
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      final userData =
          await _firestore.collection('userdata').doc(user.uid).get();
      if (userData.exists) {
        final userDataMap = userData.data() as Map<String, dynamic>;

        final experiencesData = await _firestore
            .collection('userdata')
            .doc(user.uid)
            .collection('experiences')
            .get();
        setState(() {
          _experiences = experiencesData.docs.map((doc) => doc.data()).toList();
        });
        final education = await _firestore
            .collection('userdata')
            .doc(user.uid)
            .collection('Educations')
            .get();
        setState(() {
          _education = education.docs.map((doc) => doc.data()).toList();
        });
        final userInfo =
            await _firestore.collection('userdata').doc(user.uid).get();
        setState(() {
          _userInfo = userInfo.data() as Map<String, dynamic>;
        });
        if (_userInfo.containsKey('address')) {
          address = Map<String, dynamic>.from(_userInfo['address']);
        }

        // Fetch the "skills" field from the user's Firestore document
        final skills = userDataMap['skills'] as List<dynamic>;
        setState(() {
          _skills = skills; // Assign the skills to the _skills list
        });

        // Now you can access the 'email' property from userDataMap
        print('User Email: ${userDataMap['email']}');

        // Update your widget with the user data
        setState(() {
          _userInfo = userDataMap;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _formDone == 0
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: WillPopScope(
              onWillPop: () async {
                // Return true to allow navigation back, return false to prevent it
                return false; // Prevent back navigation
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                drawer: NavBar(
                    email: _user,
                    uname: '${_userInfo['name'] ?? user?.displayName}'),
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 85, 143, 151),
                  title: Text('User Profile'.tr),
                  actions: [
                    // InkWell(onTap: _signOut, child: Icon(Icons.logout)),
                    InkWell(
                      onTap: () {
                        // Show a dialog to confirm logout
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(255, 213, 230, 230),
                              title: Text('Logout'.tr),
                              content:
                                  Text('Are you sure you want to logout?'.tr),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text(
                                    'Cancel'.tr,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 85, 143, 151)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    _signOut(); // Perform logout action
                                  },
                                  child: Text(
                                    'Logout'.tr,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 85, 143, 151)),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.logout),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                // backgroundColor: Color.fromARGB(255, 85, 143, 151),
                body: _user != null && _userInfo.isNotEmpty
                    ? SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            // Background Gradient
                            Stack(
                              alignment: Alignment
                                  .bottomCenter, // Align the white border and shading to the bottom
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          'https://media.istockphoto.com/id/1396112130/vector/candidate-resume-review-by-hr-human-resources-hiring-manager-employment-or-searching-for.jpg?s=612x612&w=0&k=20&c=jGeDkbJN-n0FXx2mzN17lISVhTYzcK1GTipg4D_coXw='),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.2, // Match the height of the image container
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.5),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 4.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                children: <Widget>[
                                  Stack(children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      child: _image != null
                                          ? CircleAvatar(
                                              child: Image.network(
                                                user!.photoURL!,
                                                fit: BoxFit.cover,
                                                width: 90,
                                                height: 90,
                                              ),
                                            )
                                          : const CircleAvatar(
                                              radius: 60,
                                              backgroundImage: AssetImage(
                                                  'assets/profile.png'),
                                            ),
                                    ),
                                    
                                  ]),
                                  Card(
                                    elevation: 0,
                                    child: Container(
                                      // margin: EdgeInsets.all(16),
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${_userInfo['name'].toString()}',
                                              style:
                                                  const TextStyle(fontSize: 21),
                                            ),
                                            Text(
                                              _userInfo['email'].toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      height: 230,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 20,
                                                right: 10,
                                                top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 2,
                                                  color: const Color.fromARGB(
                                                      120, 158, 158, 158),
                                                )),
                                            // padding: EdgeInsets.all(10),
                                            height: 175,
                                            width: 145,
                                            child: Column(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                const CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          48, 158, 158, 158),
                                                  child: Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  'Personal Information'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        elevation:
                                                            const MaterialStatePropertyAll(
                                                                0),
                                                        fixedSize:
                                                            const MaterialStatePropertyAll(
                                                                Size(120, 10)),
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Color.fromARGB(
                                                                    194,
                                                                    208,
                                                                    232,
                                                                    234))),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return UpdateInformationPage(
                                                              userInfo:
                                                                  _userInfo);
                                                        },
                                                      ));
                                                    },
                                                    child: const Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              85,
                                                              143,
                                                              151)),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 20,
                                                right: 10,
                                                top: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 2,
                                                color: const Color.fromARGB(
                                                    120, 158, 158, 158),
                                              ),
                                            ),
                                            height: 175,
                                            width: 145,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const SizedBox(height: 2),
                                                const CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          48, 158, 158, 158),
                                                  child: Icon(
                                                    Icons
                                                        .business_center_outlined,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 0),
                                                Text(
                                                  "Experience".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(height: 5),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    fixedSize:
                                                        MaterialStateProperty
                                                            .all(Size(120, 10)),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Color.fromARGB(
                                                          194, 208, 232, 234),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditExperience()),
                                                    );
                                                    // }
                                                  },
                                                  child: Text(
                                                    "Add".tr,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 85, 143, 151)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 20,
                                                right: 10,
                                                top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 2,
                                                  color: const Color.fromARGB(
                                                      120, 158, 158, 158),
                                                )),
                                            // padding: EdgeInsets.all(10),
                                            height: 175,
                                            width: 145,
                                            child: Column(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                const CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          48, 158, 158, 158),
                                                  child: Icon(
                                                    Icons.school,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 0,
                                                ),
                                                Text(
                                                  "Education".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        elevation:
                                                            const MaterialStatePropertyAll(
                                                                0),
                                                        fixedSize:
                                                            const MaterialStatePropertyAll(
                                                                Size(120, 10)),
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Color.fromARGB(
                                                                    194,
                                                                    208,
                                                                    232,
                                                                    234))),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return EditEducation();
                                                        },
                                                      ));
                                                    },
                                                    child: Text(
                                                      "Edit".tr,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              85,
                                                              143,
                                                              151)),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 20,
                                                right: 16,
                                                top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 2,
                                                  color: const Color.fromARGB(
                                                      120, 158, 158, 158),
                                                )),
                                            padding: const EdgeInsets.only(
                                                bottom: 2, top: 5),
                                            height: 175,
                                            width: 145,
                                            child: Column(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          48, 158, 158, 158),
                                                  child: Icon(
                                                    Icons.file_upload_outlined,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Resume".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15.5,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        elevation:
                                                            const MaterialStatePropertyAll(
                                                                0),
                                                        fixedSize:
                                                            const MaterialStatePropertyAll(
                                                                Size(120, 10)),
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Color.fromARGB(
                                                                    194,
                                                                    208,
                                                                    232,
                                                                    234))),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    213,
                                                                    230,
                                                                    230),
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text('Resume'
                                                                    .tr),
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close),
                                                                ),
                                                              ],
                                                            ),
                                                            content: Text(
                                                                'You can Create resume'
                                                                    .tr),
                                                            actions: [
                                                              // TextButton(
                                                              //   onPressed: () {
                                                              //     _pickResume();
                                                              //   },
                                                              //   child:
                                                              //       const Text(
                                                              //     'Upload',
                                                              //     style: TextStyle(
                                                              //         color: Color.fromARGB(
                                                              //             255,
                                                              //             85,
                                                              //             143,
                                                              //             151)),
                                                              //   ),
                                                              // ),
                                                              TextButton(
                                                                onPressed:
                                                                    _launchURL,
                                                                child: Text(
                                                                  'Create Resume'
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          85,
                                                                          143,
                                                                          151)),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      "Upload".tr,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              85,
                                                              143,
                                                              151)),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: 400,

                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 10),

                                          margin: const EdgeInsets.all(6),
                                          // padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            // color: Color.fromARGB(255, 135, 212, 229),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        'Personal Information'
                                                            .tr,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 8),
                                                    // for (var userdata in _userInfo)
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.work,
                                                        color: Colors.amber,
                                                      ),
                                                      title: Text(
                                                          'Name: ${_userInfo['name'].toString()}'),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'email: ${_userInfo['email'].toString()}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          Text(
                                                            'phone: ${_userInfo['phone'] ?? 'N/A'}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          Text(
                                                            'City: ${address['city'] ?? 'N/A'}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          Text(
                                                            'Country: ${address['country'] ?? 'N/A'}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                          Text(
                                                            'Pincode: ${address['city'] ?? 'N/A'}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 17,
                                          child: Icon(
                                            Icons.business_center_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          child: Positioned(
                                            top: 25,
                                            right: 8,
                                            child: InkWell(
                                              child: Image.network(
                                                "https://cdn-icons-png.flaticon.com/128/1827/1827933.png",
                                                color: const Color.fromARGB(
                                                    255, 85, 143, 151),
                                                height: 20,
                                              ),
                                              onTap: () async {
                                                final updatedData =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateInformationPage(
                                                                  userInfo:
                                                                      _userInfo),
                                                        ));
                                                if (updatedData != null) {
                                                  setState(() {
                                                    _userInfo = updatedData
                                                        as Map<String, dynamic>;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: 400,
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 10),
                                          margin: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        'Experience'.tr,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    // Check if _experiences is empty or null
                                                    _experiences.isEmpty
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              'Freshers',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          )
                                                        : Column(
                                                            children: [
                                                              for (var experience
                                                                  in _experiences)
                                                                ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                    Icons.work,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  title: Text(
                                                                      'Company Name: ${experience['companyName'] ?? 'N/A'}'),
                                                                  subtitle:
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Description: ${experience['description'] ?? 'N/A'}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                      Text(
                                                                        'Start Date: ${experience['startDate'] ?? 'N/A'}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                      Text(
                                                                        'End Date: ${experience['endDate'] ?? 'N/A'}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                      Text(
                                                                        'Skills: ${experience['skills'] ?? 'N/A'}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              // Add other widgets if needed
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 17,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.business_center_outlined,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditExperience(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (_experiences.isEmpty)
                                    Container() // Return an empty container if experiences is null or empty
                                  else
                                    Card(
                                      elevation: 0.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 16, right: 16, top: 10),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.all(6),
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            width: 400,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          'Skills'.tr,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Display existing skills
                                                      Wrap(
                                                        spacing: 8,
                                                        runSpacing: 8.0,
                                                        children: [
                                                          for (var experience
                                                              in _experiences)
                                                            Chip(
                                                              label: Text(
                                                                experience[
                                                                        'skills'] ??
                                                                    'N/A',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      85,
                                                                      143,
                                                                      151),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.library_books_outlined,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditExperience(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: Positioned(
                                              top: 25,
                                              right: 8,
                                              child: InkWell(
                                                child: Image.network(
                                                  "https://cdn-icons-png.flaticon.com/128/1827/1827933.png",
                                                  color: const Color.fromARGB(
                                                      255, 85, 143, 151),
                                                  height: 20,
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SkillsPage(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  Card(
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: 400,
                                          margin: const EdgeInsets.all(6),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        'Education'.tr,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    for (var Educations
                                                        in _education)
                                                      ListTile(
                                                        leading: const Icon(
                                                          Icons.school,
                                                          color: Color.fromARGB(
                                                              255,
                                                              85,
                                                              143,
                                                              151),
                                                        ),
                                                        title: Text(
                                                            'Education: ${Educations['educationType'] ?? 'N/A'}'
                                                                .tr),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'College/University: ${Educations['college'] ?? 'N/A'}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            Text(
                                                              'Completion: ${Educations['completion'] ?? 'N/A'}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            Text(
                                                              'Course: ${Educations['course'] ?? 'N/A'}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            Text(
                                                              'CGPA: ${Educations['cgpa'] ?? 'N/A'}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Positioned(
                                            top: 25,
                                            child: const Icon(
                                              Icons.school,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 25,
                                          right: 8,
                                          child: InkWell(
                                            child: Image.network(
                                              "https://cdn-icons-png.flaticon.com/128/1827/1827933.png",
                                              color: const Color.fromARGB(
                                                  255, 85, 143, 151),
                                              height: 20,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const EditEducation(),
                                                  ));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Card(
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, top: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(6),
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          width: 400,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        'Create Resume'.tr,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    TextButton(
                                                      onPressed: _launchURL,
                                                      child: Text(
                                                        'Create Resume'.tr,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    85,
                                                                    143,
                                                                    151)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 13,
                                          child: Icon(
                                            Icons.create_new_folder,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                bottomNavigationBar: const Bottom_navigator_User(),
              ),
            ),
          )
        : _buildPageForFormDoneValue(_formDone);
  }

  

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.bing.com/ck/a?!&&p=c93eb4d4215c7c43JmltdHM9MTcwOTU5NjgwMCZpZ3VpZD0yYWU5YTczYy1kZTg3LTZhMzktMzQxYy1iNTdiZGYyYTZiMjAmaW5zaWQ9NTMxNQ&ptn=3&ver=2&hsh=3&fclid=2ae9a73c-de87-6a39-341c-b57bdf2a6b20&psq=ONLINE+FREE+CV+MAKER&u=a1aHR0cHM6Ly96ZXR5LmNvbS9jdi1tYWtlcg&ntb=1'); // Replace with your desired URL
    if (!await canLaunch(url.toString())) {
      throw Exception('Could not launch $url');
    }
    await launch(url.toString());
  }

  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print("File............$file");

      try {
        // Upload file to Firebase Storage
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf');
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot storageTaskSnapshot = await uploadTask;
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        // ignore: unnecessary_brace_in_string_interps
        print("Download:${downloadUrl}");

        // Store download URL in Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore
            .collection('userdata')
            .doc(user!.uid)
            .collection("Education")
            .doc()
            .update({
          //'': 'Example PDF', // You can replace this with any metadata you want to associate with the file
          'Resume': downloadUrl,
          // Add more fields if needed
        });

        print('PDF Uploaded and URL stored in Firestore');
      } catch (e) {
        print('Error uploading PDF: $e');
      }
    } else {
      // User canceled the picker
    }
  }

  Widget _buildPageForFormDoneValue(int formDone) {
    switch (formDone) {
      case 1:
        return Page3();
      case 2:
        return AddEducationPage();
      case 3:
        return UserInfoPage();
      case 4:
        return Page4();
      case 5:
        return Page5();
      default:
        return Text('Invalid formdone value: $formDone');
    }
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(
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
        title: const Text('Page 2'),
      ),
      body: const Center(
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
        title: const Text('Page 3'),
      ),
      body: const Center(
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
        title: const Text('Page 4'),
      ),
      body: const Center(
        child: Text('This is Page 4'),
      ),
    );
  }
}

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 5'),
      ),
      body: const Center(
        child: Text('This is Page 5'),
      ),
    );
  }
}
