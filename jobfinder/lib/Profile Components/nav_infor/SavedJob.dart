// ignore_for_file: deprecated_member_use, unused_local_variable

// Import necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/Jobs/JobDetails.dart';

// SavedJob widget for displaying saved jobs
class SavedJob extends StatefulWidget {
  const SavedJob({Key? key}) : super(key: key);

  @override
  State<SavedJob> createState() => _SavedJobState();
}

class _SavedJobState extends State<SavedJob> {
  @override
  void initState() {
    super.initState();
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 85, 143, 151),
          title: Text(
            "saved job".tr, // Translated title
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SavedJobsPage(), // Display saved jobs page
      ),
    );
  }
}

// SavedJobsPage widget for displaying saved jobs list
class SavedJobsPage extends StatefulWidget {
  const SavedJobsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SavedJobsPageState createState() => _SavedJobsPageState();
}

class _SavedJobsPageState extends State<SavedJobsPage> {
  final user = FirebaseAuth.instance.currentUser;

  late List<DocumentSnapshot> _jobDocs;
  late Map<String, bool> _isLikedMap = {}; // Initialize map for liked jobs

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('saved_jobs_data')
          .doc(user!.email.toString())
          .collection('savejobdata')
          .orderBy('postedDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        }

        _jobDocs = (snapshot.data as QuerySnapshot).docs;

        if (_jobDocs.isEmpty) {
          return Center(
            child: Text('No jobs available.'), // Display message if no jobs available
          );
        }

        return ListView.builder(
          itemCount: _jobDocs.length,
          itemBuilder: (context, index) {
            var job = _jobDocs[index].data() as Map<String, dynamic>; // Get job data
            var jobId = _jobDocs[index].id;

            var companyName =
                job['companyName'] as String? ?? 'Company Name Not Provided'; // Get company name

            var jobTitle =
                job['jobTitle'] as String? ?? 'Job Title Not Provided'; // Get job title

            var salary = job['salary'] as String? ?? 'Salary Not Provided'; // Get job salary
            var postedDate = job['postedDate'] as String? ?? 'no date'; // Get job posted date

            var skills = job['skills'] as List<dynamic>?; // Get job skills
            var email = job['email'] as String? ?? 'no'; // Get recruiter's email
            var skillsText =
                skills != null ? skills.join(', ') : 'Skills Not Provided'; // Convert skills list to text

            var imageUrl = job['imageUrl'] as String? ?? ''; // Get job image URL
            int imageIndex = index % 3; // Calculate image index for demo purposes

            return Card(
              color: Colors.white,
              elevation: 5,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10), // Set card margin
              child: Row(
                children: [
                  Container(
                    width: 85,
                    color: Colors.white,
                    child: Image.asset(
                      imageIndex == 0
                          ? "assets/images/ipsum.png" // Sample image asset
                          : imageIndex == 1
                              ? "assets/images/ipsum2.png" // Sample image asset
                              : "assets/images/ipsum3.png", // Sample image asset
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
                          jobTitle, // Display job title
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
                              'Company: $companyName'.tr, // Translated company name
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
                                'Salary: ₹$salary'.tr, // Translated salary
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(145, 0, 0, 0)),
                              ),
                            ),
                            Text(
                              'Posted Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(postedDate))}'
                                  .tr, // Translated posted date
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
                                  jobtitle: jobTitle), // Navigate to job detail page
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        trailing: IconButton(
                          onPressed: () async {
                            _toggleJobSave(jobId); // Toggle job save status
                            bool isSaved = _isLikedMap.containsKey(jobId)
                                ? _isLikedMap[jobId]!
                                : false; // Check if job is already saved
                            if (isSaved) {
                              await _savedJobsRef.doc(jobId).delete(); // Delete job from saved list
                            }
                          },
                          icon: Icon(Icons.delete), // Delete icon
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

  CollectionReference<Map<String, dynamic>> _savedJobsRef = FirebaseFirestore
      .instance
      .collection('saved_jobs_data')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .collection('savejobdata'); // Reference to saved jobs collection

  // Function to toggle job save status
  Future<void> _toggleJobSave(String jobId) async {
    bool isSaved = _isLikedMap.containsKey(jobId) ? _isLikedMap[jobId]! : false;
    if (isSaved) {
      await _savedJobsRef.doc(jobId).delete(); // Delete job if already saved
    } else {
      var jobData = (await FirebaseFirestore.instance
              .collection('jobsposted')
              .doc(jobId)
              .get())
          .data(); // Get job data
      await _savedJobsRef
          .doc(jobId)
          .set({'timestamp': FieldValue.serverTimestamp(), ...?jobData}); // Save job data
    }
    setState(() {
      _isLikedMap[jobId] = !isSaved; // Update saved job status
    });
  }
}
