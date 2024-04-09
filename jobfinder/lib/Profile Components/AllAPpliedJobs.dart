// Importing necessary libraries
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Components/ChatWithRecruiter.dart'; // Importing a custom component
import 'package:jobfinder/user_admin/bottom_navigator.dart'; // Importing a custom component

// Class for Chat with Recruiter Page
class ChatWithRecruiterPage extends StatelessWidget {
  final String jobId;
  final String userId;

  ChatWithRecruiterPage({required this.jobId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Recruiter'), // AppBar title
      ),
      body: Center(
        child: Text('Job ID: $jobId\nUser ID: $userId'), // Displaying Job ID and User ID
      ),
    );
  }
}

// Class for Jobs Posted Page
class JobsPostedPage extends StatefulWidget {
  @override
  _JobsPostedPageState createState() => _JobsPostedPageState();
}

class _JobsPostedPageState extends State<JobsPostedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User currentUser; // Current user

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Getting current user on initialization
  }

  Future<void> _getCurrentUser() async {
    currentUser = _auth.currentUser!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removing the back button from AppBar
        
        title: Text('All Job Applied'.tr, style: TextStyle(color: Colors.white)), // AppBar title
        backgroundColor: Color.fromARGB(255, 85, 143, 151), // AppBar background color
      ),
      body: currentUser == null
          ? Center(child: CircularProgressIndicator()) // Displaying CircularProgressIndicator if currentUser is null
          : StreamBuilder(
              stream: _firestore.collection('jobsposted').snapshots(), // Stream of jobsposted collection from Firestore
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final jobDocs = snapshot.data?.docs ?? []; // List of documents from the snapshot

                return ListView.builder(
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    final jobDoc = jobDocs[index]; // Current job document
                    final applicationsCollection =
                        jobDoc.reference.collection('applications'); // Collection of applications for current job
                    final applicationDoc =
                        applicationsCollection.doc(currentUser.uid); // Document for current user's application for this job

                    return FutureBuilder(
                      future: applicationDoc.get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> applicationSnapshot) {
                        if (applicationSnapshot.connectionState ==
                            ConnectionState.waiting) {
                        }

                        final jobId = jobDoc.id; // Job ID

                        if (applicationSnapshot.hasError) {
                          return Text('Error: ${applicationSnapshot.error}');
                        }

                        if (applicationSnapshot.hasData &&
                            applicationSnapshot.data!.exists) {
                          final jobData = jobDoc.data() as Map<String, dynamic>; // Data of current job document
                          final companyName = jobData['companyName'] as String?; // Company name
                          final jobTitle = jobData['jobTitle'] as String?; // Job title
                          final email = jobData['email'] as String?; // Email
                          try {
// FCM Token
                          } catch (e) {
                          }

                          if (companyName != null && jobTitle != null) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage( // Navigate to ChatPage when tapped
                                        jobId: jobId,
                                        applicationId: currentUser.uid,
                                        email: email.toString()),
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
                                  title: Text('Company: $companyName'), // Displaying company name
                                  subtitle: Text('Job Title: $jobTitle'), // Displaying job title
                                  trailing: Icon(
                                    Icons.chat, // Chat icon
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text('Job ID: $jobId (No Application)'), // Displaying Job ID if no application
                            );
                          }
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: Bottom_navigator_User(), // Bottom navigation bar
    );
  }
}

// Main function to run the application
void main() {
  runApp(MaterialApp(
    home: JobsPostedPage(), // Starting point of the application
  ));
}

// Class for home applied page
class home_applied extends StatefulWidget {
  const home_applied({super.key});

  @override
  State<home_applied> createState() => _home_appliedState();
}

class _home_appliedState extends State<home_applied> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    currentUser = _auth.currentUser!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Back icon
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Pop the current route when back button is pressed
          },
        ),
        title:
            Text('All Job Applied'.tr, style: TextStyle(color: Colors.white)), // AppBar title
        backgroundColor: Color.fromARGB(255, 85, 143, 151), // AppBar background color
      ),
      body: currentUser == null
          ? Center(child: CircularProgressIndicator()) // Displaying CircularProgressIndicator if currentUser is null
          : StreamBuilder(
              stream: _firestore.collection('jobsposted').snapshots(), // Stream of jobsposted collection from Firestore
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final jobDocs = snapshot.data?.docs ?? []; // List of documents from the snapshot

                return ListView.builder(
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    final jobDoc = jobDocs[index]; // Current job document
                    final applicationsCollection =
                        jobDoc.reference.collection('applications'); // Collection of applications for current job
                    final applicationDoc =
                        applicationsCollection.doc(currentUser.uid); // Document for current user's application for this job

                    return FutureBuilder(
                      future: applicationDoc.get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot> applicationSnapshot) {
                        if (applicationSnapshot.connectionState ==
                            ConnectionState.waiting) {
                        }

                        final jobId = jobDoc.id; // Job ID

                        if (applicationSnapshot.hasError) {
                          return Text('Error: ${applicationSnapshot.error}');
                        }

                        if (applicationSnapshot.hasData &&
                            applicationSnapshot.data!.exists) {
                          final jobData = jobDoc.data() as Map<String, dynamic>; // Data of current job document
                          final companyName = jobData['companyName'] as String?; // Company name
                          final jobTitle = jobData['jobTitle'] as String?; // Job title
                          final email = jobData['email'] as String?; // Email
                          try {
// FCM Token
                          } catch (e) {
                          }

                          if (companyName != null && jobTitle != null) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      jobId: jobId,
                                      applicationId: currentUser.uid,
                                      email: email.toString(),
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
                                  title: Text('Company: $companyName'), // Displaying company name
                                  subtitle: Text('Job Title: $jobTitle'), // Displaying job title
                                  trailing: Icon(
                                    Icons.chat, // Chat icon
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text('Job ID: $jobId (No Application)'), // Displaying Job ID if no application
                            );
                          }
                        } else {
                          return SizedBox.shrink();
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
