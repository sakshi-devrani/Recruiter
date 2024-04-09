import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class adminInfo extends StatefulWidget {
  const adminInfo({Key? key}) : super(key: key);

  @override
  State<adminInfo> createState() => _adminInfoState();
}

class _adminInfoState extends State<adminInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // User object to store current user data
  Map<String, dynamic> _companyInfo = {}; // Map to store company information
  String certificateName = ''; // Variables to store certificate information
  String organization = '';
  String issuedYear = '';
  late List<int> years; // List of years
  late int selectedYear; // Selected year
  List<Map<String, dynamic>> certificates = []; // List to store certificates

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the widget initializes
  }


  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
      // Retrieve user data from Firestore
      final userData = await _firestore.collection('admin').doc(user.uid).get();
      if (userData.exists) {
        final userDataMap = userData.data() as Map<String, dynamic>;
        setState(() {
          _companyInfo = userDataMap; // Set company information
        });
      }
    }
  }

  File? _image; // File object for profile image

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: const Color.fromARGB(255, 85, 143, 151),
          title: Text('Company Information'.tr), // App bar title, might be translated text
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              // Background Gradient
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Background image
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://media.istockphoto.com/id/1396112130/vector/candidate-resume-review-by-hr-human-resources-hiring-manager-employment-or-searching-for.jpg?s=612x612&w=0&k=20&c=jGeDkbJN-n0FXx2mzN17lISVhTYzcK1GTipg4D_coXw='),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
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
                  // Divider line
                  Container(
                    height: 4.0,
                    color: Colors.white,
                  ),
                ],
              ),

              // User profile information
              Container(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: <Widget>[
                    // Profile picture
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
                                backgroundImage:
                                    AssetImage('assets/profile.png'),
                              ),
                      ),
                    ]),
                    // Company information card
                    Card(
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
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
                                style: const TextStyle(fontSize: 21),
                              ),
                              Text(
                                '${_companyInfo['email'].toString()}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Company details card
                    Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 400,
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10),
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Company Information'.tr, // Card title, might be translated text
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      // Company details
                                      ListTile(
                                        leading: const Icon(
                                          Icons.work,
                                          color: Colors.amber,
                                        ),
                                        title: Text(
                                            'Company Name: ${_companyInfo['company'].toString()}'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Email: ${_companyInfo['email'].toString()}',
                                              style: const TextStyle(
                                                  fontSize: 15),
                                            ),

                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Contact: ${_companyInfo['contact']}',
                                              style: const TextStyle(
                                                  fontSize: 15),
                                            ),
                                          
                                            Text(
                                              'Location: ${_companyInfo['location'].toString()}',
                                              style: const TextStyle(
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Website: ${_companyInfo['website'].toString()}',
                                              style: const TextStyle(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
