// ignore_for_file: unused_local_variable, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/Components/BottomNavigator.dart';

// StatefulWidget for displaying a list of jobs
class jobsList extends StatefulWidget {
  @override
  State<jobsList> createState() => _jobsListState();
}

// State class for the jobsList widget
class _jobsListState extends State<jobsList> {
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
            'j1'.tr, // Translate 'j1' text
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigate to notifications page
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
                      'find'.tr, // Translate 'find' text
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
                child: JobList(), // Display the list of jobs
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(), // Display the bottom navigation bar
      ),
    );
  }
}

// StatefulWidget for displaying a list of jobs
class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

// State class for the JobList widget
class _JobListState extends State<JobList> {
  Map<String, bool> _isLikedMap = {}; // Map to store like status for each job
  late User _user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('jobsposted').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> jobDocs = snapshot.data!.docs;

        if (jobDocs.isEmpty) {
          return Center(
            child: Text('No jobs available.'),
          );
        }

        return ListView.builder(
          itemCount: jobDocs.length,
          itemBuilder: (context, index) {
            var job = jobDocs[index].data() as Map<String, dynamic>;
            var jobId = jobDocs[index].id;

            var companyName =
                job['companyName'] as String? ?? 'Company Name Not Provided';

            var jobTitle =
                job['jobTitle'] as String? ?? 'Job Title Not Provided';

            var salary = job['salary'] as String? ?? 'Salary Not Provided';
            var postedDate = job['postedDate'] as String? ?? 'no date';

            var skills = job['skills'] as List<dynamic>?;

            var skillsText =
                skills != null ? skills.join(', ') : 'Skills Not Provided';

            var imageUrl = job['imageUrl'] as String? ?? '';
            int imageIndex = index % 3;

            bool isLiked =
                _isLikedMap.containsKey(jobId) ? _isLikedMap[jobId]! : false;

            return Card(
              color: Colors.white,
              elevation: 5,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: Color.fromARGB(43, 158, 158, 158),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                'Salary: ₹$salary',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(145, 0, 0, 0)),
                              ),
                            ),
                            Text(
                              'Skills: $skillsText',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 60, 106, 176),
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
                          // Navigate to job detail page
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle like status
                              _isLikedMap[jobId] =
                                  !_isLikedMap.containsKey(jobId)
                                      ? true
                                      : !_isLikedMap[jobId]!;
                            });
                            // Navigate to saved jobs page
                          },
                          child: Icon(
                            _isLikedMap.containsKey(jobId) &&
                                    _isLikedMap[jobId]!
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: _isLikedMap.containsKey(jobId) &&
                                    _isLikedMap[jobId]!
                                ? Color.fromARGB(255, 85, 143, 151)
                                : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Function to save a job to Firestore
  Future<void> saveJob(String jobId, Map<String, dynamic> jobData) async {
    try {
      await FirebaseFirestore.instance
          .collection('saved_jobs')
          .doc(_user.uid)
          .collection('jobs')
          .doc(jobId)
          .set(jobData);
    } catch (e) {
      print('Error saving job: $e');
    }
  }
}
