// ignore_for_file: unused_field

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Components/BottomNavigator.dart';
import 'package:jobfinder/Profile%20Components/company_info.dart';
import 'package:jobfinder/UpdateProfile/updateadmincomapny.dart';
import 'package:jobfinder/adminProfile/admin_nav_bar.dart';
import 'package:jobfinder/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobProfilePage extends StatefulWidget {
  const JobProfilePage({Key? key}) : super(key: key);

  @override
  State<JobProfilePage> createState() => _JobProfilePageState();
}

class _JobProfilePageState extends State<JobProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic> _companyInfo = {};
  File? _file;
  late SharedPreferences _prefs;
  List<dynamic> _skills = [];
  int _formDone = 0;
  String certificateName = '';
  String organization = '';
  String issuedYear = '';
  late List<int> years;
  late int selectedYear;
  List<Map<String, dynamic>> certificates = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
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
          _companyInfo = userDataMap;
        });
      }
    }
  }

  File? _image;

  @override
  Widget build(BuildContext context) {
    return _formDone == 0
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              drawer: Admin_NavBar(
                  email: '${_companyInfo['email'].toString()}',
                  uname: '${_companyInfo['company'].toString()}'),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 85, 143, 151),
                title: Text('Admin Profile'.tr),
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
                            title: Text('logout'.tr),
                            content:
                                Text('Are you sure you want to logout?'.tr),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text(
                                  'cancel'.tr,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 85, 143, 151)),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  _signOut(); // Perform logout action
                                },
                                child: Text(
                                  'logout'.tr,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 85, 143, 151)),
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
              body: _user != null && _companyInfo.isNotEmpty
                  ? SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          // Background Gradient
                          Stack(
                            alignment: Alignment.bottomCenter,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                              _user!.photoURL!,
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
                                            '${_companyInfo['company'].toString()}',
                                            style:
                                                const TextStyle(fontSize: 21),
                                          ),
                                          Text(
                                            '${_companyInfo['email'].toString()}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
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
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      'Company Information'.tr,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.work,
                                                      color: Colors.amber,
                                                    ),
                                                    title: Text(
                                                        'Company Name: ${_companyInfo['company'].toString()}'),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'Email: ${_companyInfo['email'].toString()}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'Contact: ${_companyInfo['contact']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                        Text(
                                                          'Location: ${_companyInfo['location'].toString()}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'Website: ${_companyInfo['website'].toString()}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
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
                                                              EditCompnay_details(
                                                                  userInfo:
                                                                      _companyInfo)));
                                              if (updatedData != null) {
                                                setState(() {
                                                  _companyInfo = updatedData
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar: BottomNavigatorExample(),
            ),
          )
        : _buildPageForFormDoneValue(_formDone);
  }

  Widget _buildPageForFormDoneValue(int formDone) {
    switch (formDone) {
      case 1:
        return CompanyInformationPage();
      case 2:
        return Page2();
      case 3:
        return Page3();
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
