
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfinder/Jobs/ApplicationFormPage.dart';
import 'package:share/share.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId; // Unique identifier for the job
  final String jobtitle; // Title of the job
  final String jobemail; // Email associated with the job

  JobDetailPage({
    required this.jobId,
    required this.jobtitle,
    required this.jobemail,
  }); // Constructor to initialize job details

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final User? user = FirebaseAuth.instance.currentUser; // Current user

  bool hasApplied = false; // Flag to check if the user has applied for the job
  bool shouldReload = false; // Flag to check if the page should reload

  @override
  void initState() {
    super.initState();
    checkApplicationStatus(); // Check application status when the page initializes
  }

  // Method to check if the user has applied for the job
  void checkApplicationStatus() async {
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('jobsposted')
          .doc(widget.jobId)
          .collection('applications')
          .doc(user!.uid)
          .get();

      setState(() {
        hasApplied = snapshot.exists; // Set hasApplied flag based on snapshot existence
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          'Job Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('jobsposted')
            .doc(widget.jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;
          var jobTitle =
              jobData['jobTitle'] as String? ?? 'Job Title Not Provided';
          var companyName =
              jobData['companyName'] as String? ?? 'Company Name Not Provided';
          var jobDescription = jobData['jobDescription'] as String? ??
              'Job Description Not Provided';
          var salary = jobData['salary'] as String? ?? 'Salary Not Provided';
          var companyImageURL = jobData['companyImageURL'] as String? ?? '';
          var skills = jobData['skills'] as List<dynamic>?;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget to display job image
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          'assets/images/ipsum.png',
                          width: 340,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // Widgets to display job details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Widget to display job title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            jobTitle,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _shareViaMessage(context); // Share job details
                              },
                              icon: Icon(Icons.share))
                        ],
                      ),
                      SizedBox(height: 10.0),
                      // Widgets to display company name and salary
                      Text(
                        'Company: $companyName',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Salary: $salary',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Widget to display job description
                      Container(
                        width: 450,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job Description',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              jobDescription,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Widget to display company image if available
                if (companyImageURL.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          companyImageURL,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                // Widget to display required skills
                if (skills != null && skills.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 300,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skills Required',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(171, 82, 6, 6),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: skills.map((skill) {
                                  return Chip(
                                    label: Text(
                                      skill,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8.0,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                // Widget to handle job application
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!hasApplied) {
                        final shouldReloadFromSecondPage = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicationFormPage(
                              jobId: widget.jobId,
                              currentUser: user,
                              jobemail: widget.jobemail,
                              jobtitle: widget.jobtitle,
                            ),
                          ),
                        );
                        if (shouldReloadFromSecondPage == true) {
                          setState(() {
                            shouldReload = true;
                          });
                        }
                      }
                    },
                    child: Text(
                      hasApplied ? 'Already Applied' : 'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 85, 143, 151),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Method to share job details via message
  void _shareViaMessage(BuildContext context) {
    final String text = 'Check out this job finder app: https://recruiter.com';
    final String t1 = widget.jobtitle.toString();
    final String t2 = widget.jobemail.toString();

    Share.share(
      '$text\nJob Title: $t1\nJob Email: $t2',
      subject: t1,
    );
  }
}
