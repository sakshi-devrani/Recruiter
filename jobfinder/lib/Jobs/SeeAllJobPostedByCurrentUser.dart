import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/Components/BottomNavigator.dart';
import 'package:jobfinder/Jobs/seeSpecificJobByCurrentUser.dart';

class SeeAllooJobPostedPage extends StatefulWidget {
  @override
  _SeeAllooJobPostedPageState createState() => _SeeAllooJobPostedPageState();
}

class _SeeAllooJobPostedPageState extends State<SeeAllooJobPostedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'posted job'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 85, 143, 151),
      ),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No posted jobs found.'.tr,
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
                      final documentId = document.id;

                      return Container(
                        height: 90,
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          color: Color.fromARGB(255, 204, 225, 228),
                          child: ListTile(
                            title: Text(
                              jobTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Posted Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(postedDate))}',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 13),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _editJob(document); // Edit job details
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 85, 143, 151),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(documentId); // Show delete confirmation dialog
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.navigate_next_rounded,
                                    color: Color.fromARGB(255, 85, 143, 151),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SeeSpecificJobApplicants(
                                          documentId: documentId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }

  // Method to edit job details
  void _editJob(DocumentSnapshot jobSnapshot) {
    // Initialize text controllers with existing job details
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

    // Show edit job dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 213, 230, 230),
        title: Text('Edit Job'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text fields to edit job details
              TextField(
                controller: jobTitleController,
                decoration: InputDecoration(labelText: 'jt'.tr),
              ),
              TextField(
                controller: jobDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'jd'.tr),
              ),
              TextField(
                controller: companyNameController,
                decoration: InputDecoration(labelText: 'cn'.tr),
              ),
              TextField(
                controller: profileLinkController,
                decoration: InputDecoration(labelText: 'link'.tr),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'salary'.tr),
              ),
              TextField(
                controller: skillsController,
                decoration: InputDecoration(labelText: 'skills'.tr),
              ),
            ],
          ),
        ),
        actions: [
          // Buttons to cancel or save the edited job details
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 85, 143, 151)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: const ButtonStyle(
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
                    content: Text('Job updated successfully'.tr),
                  ),
                );
                Navigator.pop(context); // Close dialog
              }).catchError((error) {
                print('Failed to update job: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update job'.tr),
                  ),
                );
              });
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  // Method to delete a job
  void _deleteJob(String jobId, Function(String) onDelete) {
    FirebaseFirestore.instance.collection('jobsposted').doc(jobId).delete();
    onDelete(jobId);
  }

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(String jobId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 213, 230, 230),
          title: Text(
            "Confirm Delete".tr,
          ),
          content: Text("Are you sure you want to delete this job?".tr),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                "cancel".tr,
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
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                "Delete".tr,
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

void main() {
  runApp(MaterialApp(
    home: SeeAllooJobPostedPage(),
  ));
}
