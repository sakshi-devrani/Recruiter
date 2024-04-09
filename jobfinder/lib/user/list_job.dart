// ignore_for_file: unused_local_variable, deprecated_member_use, unused_element, unused_field
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/Jobs/JobDetails.dart';
import 'package:jobfinder/Profile%20Components/AllAPpliedJobs.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/SavedJob.dart';
import 'package:jobfinder/user_admin/bottom_navigator.dart';
import 'package:jobfinder/welcome.dart';

// StatefulWidget for displaying the list of jobs for a user
class User_job_list extends StatefulWidget {
  @override
  State<User_job_list> createState() => _User_job_listState();
}

class _User_job_listState extends State<User_job_list> {
  int _formDone = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    checkform();
  }

  // Function to check if the user has completed a form, if not, set a default value
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

  // Function to sign out the user
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

  @override
  Widget build(BuildContext context) {
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
            'j1'.tr,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SavedJob(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => home_applied(),
                  ),
                );
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
                      'hello'.tr,
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
                      'find'.tr,
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
                      'j1'.tr,
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
                flex: 1,
                child: JobList(userEmail: _user?.email ?? ''),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Bottom_navigator_User(),
      ),
    );
  }
}

// StatefulWidget for displaying the list of jobs
class JobList extends StatefulWidget {
  final String userEmail;

  const JobList({Key? key, required this.userEmail}) : super(key: key);

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late Map<String, bool> _isLikedMap;
  late CollectionReference<Map<String, dynamic>> _savedJobsRef;

  @override
  void initState() {
    super.initState();
    _isLikedMap = {};
    _savedJobsRef = FirebaseFirestore.instance
        .collection('saved_jobs_data')
        .doc(widget.userEmail)
        .collection('savejobdata');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('jobsposted')
          .orderBy('postedDate', descending: true)
          .snapshots(),
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
            var email = job['email'] as String? ?? 'no';
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
                    width: 85,
                    color: Colors.white,
                    child: Image.asset(
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
                      padding: EdgeInsets.only(top: 20),
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
                              'Posted Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(postedDate))}',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailPage(
                                jobId: jobId,
                                jobemail: email,
                                jobtitle: jobTitle,
                              ),
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),

                        trailing: Column(
                          children: [
                            IconButton(
                              onPressed: () => _toggleJobSave(jobId),
                              icon: StreamBuilder(
                                stream: _savedJobsRef.doc(jobId).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Icon(
                                      Icons.bookmark_border,
                                      color: Colors.grey,
                                      size: 30,
                                    );
                                  }

                                  var isSaved = snapshot.data!.exists;
                                  return Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isSaved
                                        ? Color.fromARGB(255, 85, 143, 151)
                                        : Colors.grey,
                                    size: 30,
                                  );
                                },
                              ),
                            ),
                          ],
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

  // Function to toggle saving a job
  Future<void> _toggleJobSave(String jobId) async {
    bool isSaved = _isLikedMap.containsKey(jobId) ? _isLikedMap[jobId]! : false;
    if (isSaved) {
      await _savedJobsRef.doc(jobId).delete();
    } else {
      var jobData = (await FirebaseFirestore.instance
              .collection('jobsposted')
              .doc(jobId)
              .get())
          .data();
      await _savedJobsRef
          .doc(jobId)
          .set({'timestamp': FieldValue.serverTimestamp(), ...?jobData});
    }
    setState(() {
      _isLikedMap[jobId] = !isSaved;
    });
  }
}
