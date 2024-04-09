// ignore_for_file: unused_element, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/Components/BottomNavigator.dart';

// StatefulWidget for managing the Applicant page
class Applicant extends StatefulWidget {
  const Applicant({super.key});

  @override
  State<Applicant> createState() => _ApplicantState();
}

// State class for the Applicant widget
class _ApplicantState extends State<Applicant> {
  int _formDone = 0; // Variable to track the completion status of the form
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  User? _user; // Current user

  @override
  void initState() {
    super.initState();
    checkform(); // Check the completion status of the form when the widget initializes
  }

  // Function to check the completion status of the form in Firestore
  Future<void> checkform() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('userdata').doc(_user!.uid).get();

      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('formdone')) {
          setState(() {
            _formDone = userData['formdone'];
          });
        } else {
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

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 85, 143, 151),
          title: Text(
            'Job'.tr, // Translate 'Job' text
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigation action to notifications page
              },
            ),
            IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigation action to chat page
              },
            ),
          ],
        ),
        body: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'See All Posted'.tr, // Translate 'See All Posted' text
                      style: TextStyle(
                        color: Color.fromARGB(255, 85, 143, 151),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'j1'.tr, // Translate 'j1' text
                      style: TextStyle(
                        color: Color.fromARGB(255, 85, 143, 151),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10), // Adjust the height as needed
              Expanded(
                child: jobsList_Admin(), // Displaying list of jobs for admin
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(), // Displaying bottom navigation bar
      ),
    );
  }
}

// StatefulWidget for displaying the list of jobs for admin
class jobsList_Admin extends StatefulWidget {
  @override
  _jobsList_AdminState createState() => _jobsList_AdminState();
}

// State class for the jobsList_Admin widget
class _jobsList_AdminState extends State<jobsList_Admin> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: _auth.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final currentUser = snapshot.data;

            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('jobsposted')
                  .where('postedBy', isEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No posted jobs found.',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index];
                      final jobTitle = document['jobTitle'];
                      final postedDate = document['postedDate'];
                      var companyName = document['companyName'] as String? ??
                          'Company Name Not Provided';

                      var salary = document['salary'] as String;

                      var skills = document['skills'] as List<dynamic>?;

                      var skillsText = skills != null
                          ? skills.join(', ')
                          : 'Skills Not Provided';

                      int imageIndex = index % 3;
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 85,
                              child: Image.asset(
                                colorBlendMode: BlendMode.modulate,
                                imageIndex == 0
                                    ? "assets/images/ipsum.png"
                                    : imageIndex == 1
                                        ? "assets/images/ipsum2.png"
                                        : "assets/images/ipsum3.png",
                                fit: BoxFit.fitWidth,
                                height: 145,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 145,
                                padding: EdgeInsets.only(),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(7),
                                        bottomRight: Radius.circular(7))),
                                child: ListTile(
                                  title: Text(
                                    jobTitle,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Company: $companyName',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                43, 158, 158, 158),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Text(
                                          'Salary: ₹$salary',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(145, 0, 0, 0)),
                                        ),
                                      ),
                                      Text(
                                        'Skills: $skillsText',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 60, 106, 176),
                                        ),
                                      ),
                                      Text(
                                        'Posted Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(postedDate))}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Action to view job details
                                  },
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Function to edit job details
  void _editJob(DocumentSnapshot jobSnapshot) {
    // Initializing text controllers with current job details
    TextEditingController jobTitleController =
        TextEditingController(text: jobSnapshot['jobTitle']);
    TextEditingController jobDescriptionController =
        TextEditingController(text: jobSnapshot['jobDescription']);
    TextEditingController companyNameController =
        TextEditingController(text: jobSnapshot['companyName']);
    TextEditingController profileLinkController =
        TextEditingController(text: jobSnapshot['profileLink']);
    TextEditingController salaryController =
        TextEditingController(text: jobSnapshot['salary']);
    TextEditingController skillsController =
        TextEditingController(text: jobSnapshot['skills'].join(', '));

    // Displaying edit job dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 213, 230, 230),
        title: Text('Edit Job'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              TextField(
                controller: jobDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Job Description'),
              ),
              TextField(
                controller: companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
              ),
              TextField(
                controller: profileLinkController,
                decoration: InputDecoration(labelText: 'Profile Link'),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
              ),
              TextField(
                controller: skillsController,
                decoration:
                    InputDecoration(labelText: 'Skills (comma-separated)'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 85, 143, 151)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 85, 143, 151)),
            ),
            onPressed: () {
              // Update job details in Firestore
              String jobId = jobSnapshot.id;
              FirebaseFirestore.instance
                  .collection('jobsposted')
                  .doc(jobId)
                  .update({
                'jobTitle': jobTitleController.text,
                'jobDescription': jobDescriptionController.text,
                'companyName': companyNameController.text,
                'profileLink': profileLinkController.text,
                'salary': salaryController.text,
                'skills': skillsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
              }).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Job updated successfully'),
                  ),
                );
                Navigator.pop(context);
              }).catchError((error) {
                print('Failed to update job: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update job'),
                  ),
                );
              });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Function to delete a job
  void _deleteJob(String jobId, Function(String) onDelete) {
    FirebaseFirestore.instance.collection('jobsposted').doc(jobId).delete();
    onDelete(jobId);
  }

  // Function to show delete confirmation dialog
  void _showDeleteConfirmationDialog(String jobId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 213, 230, 230),
          title: Text(
            "Confirm Delete",
          ),
          content: Text("Are you sure you want to delete this job?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteJob(jobId, (deletedJobId) {
                  setState(() {
                    // Remove the job from the list
                    // You can remove the job using its ID from the list of jobs here
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Color.fromARGB(255, 85, 143, 151),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Main function to run the app
void main() {
  runApp(MaterialApp(
    home: jobsList_Admin(),
  ));
}
