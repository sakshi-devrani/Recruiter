// ignore_for_file: unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/chats/chatByRecruiter.dart';

class Applied_info extends StatefulWidget {
  final String documentId;

  Applied_info({required this.documentId});
  @override
  State<Applied_info> createState() => _Applied_infoState();
}

class _Applied_infoState extends State<Applied_info> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Applicant Information', // Title of the page
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151), // App bar color
      ),
      body: FutureBuilder<User?>(
        future: _auth.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display error if any
            }

            final currentUser = snapshot.data;

            return StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('jobsposted')
                  .doc(widget.documentId)
                  .snapshots(), // Stream builder to get job details
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Job not found.'));
                } else {
                  final jobData = snapshot.data!.data() as Map<String, dynamic>;
                  final jobTitle = jobData['jobTitle']; // Get job title
                  final jobDescription = jobData['jobDescription']; // Get job description
                  final postedDate = jobData['postedDate']; // Get posted date

                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('jobsposted')
                        .doc(widget.documentId)
                        .collection('applications')
                        .snapshots(), // Stream builder to get applications
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No applications found.'));
                      } else {
                        final applicationDocs = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: applicationDocs.length,
                          itemBuilder: (context, index) {
                            final applicationData = applicationDocs[index]
                                .data() as Map<String, dynamic>;
                            final availability =
                                applicationData['availability']; // Get availability
                            final email = applicationData['email']; // Get email
                            final experience = applicationData['experience']; // Get experience
                            final projects = applicationData['projects']; // Get projects
                            final salaryExpectation =
                                applicationData['salaryExpectation']; // Get salary expectation

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRecruiter(
                                      email: applicationData['email'], // Pass email to chat screen
                                      jobId: widget.documentId, // Pass job ID to chat screen
                                      applicationId: applicationDocs[index].id, // Pass application ID to chat screen
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(78, 171, 208, 211),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text('Availability: $availability'), // Display availability
                                    trailing: const Icon(
                                      Icons.chat,
                                      color: Color.fromARGB(255, 85, 143, 151),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Experience: $experience'), // Display experience
                                        Text('Projects: $projects'), // Display projects
                                        Text(
                                            'Salary Expectation: $salaryExpectation'), // Display salary expectation
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
