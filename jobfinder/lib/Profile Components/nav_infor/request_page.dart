// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Components/ChatWithRecruiter.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User currentUser; // Variable to hold current user

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Fetch current user when the widget initializes
  }

  // Fetch the current user asynchronously
  Future<void> _getCurrentUser() async {
    currentUser = _auth.currentUser!; // Get the current user from FirebaseAuth
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request For Job Applied'.tr, // App Bar Title
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 85, 143, 151), // App Bar Background Color
      ),
      body: currentUser == null // If current user is null, show loading indicator
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: _firestore.collection('jobsposted').snapshots(), // Stream of job posts from Firestore
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching data
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error message if any
                }

                final jobDocs = snapshot.data?.docs ?? []; // Extract job documents from snapshot

                return ListView.builder(
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    final jobDoc = jobDocs[index]; // Get a single job document
                    final applicationsCollection =
                        jobDoc.reference.collection('applications'); // Collection reference for applications
                    final applicationDoc =
                        applicationsCollection.doc(currentUser.uid); // Document reference for current user's application

                    return FutureBuilder(
                      future: applicationDoc.get(), // Fetch application document
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> applicationSnapshot) {
                        if (applicationSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show loading indicator while fetching application
                        }

                        final jobId = jobDoc.id; // Get job ID
                        if (applicationSnapshot.hasError) {
                          return Text('Error: ${applicationSnapshot.error}'); // Show error message if any
                        }

                        if (applicationSnapshot.hasData &&
                            applicationSnapshot.data!.exists) {
                          final jobData = jobDoc.data() as Map<String, dynamic>; // Extract job data
                          final companyName = jobData['companyName'] as String?; // Get company name
                          final jobTitle = jobData['jobTitle'] as String?; // Get job title

                          if (companyName != null && jobTitle != null) {
                            // If company name and job title are not null, display job details
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      email:
                                          _auth.currentUser!.email.toString(), // Pass current user's email to chat page
                                      jobId: jobId, // Pass job ID to chat page
                                      applicationId: currentUser.uid, // Pass current user's ID to chat page
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(6),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(112, 85, 143, 151),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Text('Company: $companyName'), // Display company name
                                  subtitle: Text('Job Title: $jobTitle'), // Display job title
                                  trailing: Icon(
                                    Icons.chat, // Chat icon
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text('Job ID: $jobId (No Application)'), // Display job ID if no application exists
                            );
                          }
                        } else {
                          return SizedBox.shrink(); // If no data or data doesn't exist, return an empty container
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
