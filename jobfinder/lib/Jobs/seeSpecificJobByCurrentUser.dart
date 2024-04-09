// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/chats/chatByRecruiter.dart';

class SeeSpecificJobApplicants extends StatelessWidget {
  final String documentId; // ID of the job document
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firebase Firestore instance

  SeeSpecificJobApplicants({required this.documentId}); // Constructor to initialize the document ID

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
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text(
          'Applicant'.tr, // Translation key for 'Applicant'
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
      ),
      body: FutureBuilder<User?>(
        future: _auth.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final currentUser = snapshot.data;

            return StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('jobsposted')
                  .doc(documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Job not found.'));
                } else {
                  final jobData = snapshot.data!.data() as Map<String, dynamic>;
                  final jobTitle = jobData['jobTitle']; // Title of the job
                  final jobDescription = jobData['jobDescription']; // Description of the job
                  final postedDate = jobData['postedDate']; // Date the job was posted

                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('jobsposted')
                        .doc(documentId)
                        .collection('applications')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No applications found.'.tr));
                      } else {
                        final applicationDocs = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: applicationDocs.length,
                          itemBuilder: (context, index) {
                            final applicationData = applicationDocs[index]
                                .data() as Map<String, dynamic>;
                            final availability =
                                applicationData['availability']; // Availability of the applicant
                            final email = applicationData['email']; // Email of the applicant
                            final experience = applicationData['experience']; // Experience of the applicant
                            final projects = applicationData['projects']; // Projects of the applicant
                            final salaryExpectation =
                                applicationData['salaryExpectation']; // Salary expectation of the applicant

                            return GestureDetector(
                              onTap: () {
                                // Navigate to chat screen when tapping on an applicant
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRecruiter(
                                      email: applicationData['email'],
                                      jobId: documentId,
                                      applicationId: applicationDocs[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(94, 181, 205, 207),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(email),
                                    trailing: Icon(
                                      Icons.chat,
                                      color: Color.fromARGB(255, 85, 143, 151),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Availability: $availability'),
                                        Text('Experience: $experience'),
                                        Text('Projects: $projects'),
                                        Text(
                                            'Salary Expectation: $salaryExpectation'),
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
