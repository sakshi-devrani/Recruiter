// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Components/BottomNavigator.dart';

// StatefulWidget for posting a job
class JobPostingPage extends StatefulWidget {
  @override
  _JobPostingPageState createState() => _JobPostingPageState();
}

// State class for the JobPostingPage widget
class _JobPostingPageState extends State<JobPostingPage> {
  // GlobalKey for accessing the form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text editing controllers for various input fields
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _profileLinkController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'post'.tr, // Translate 'post' text
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 85, 143, 151),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text field for job title
                  buildTextField(
                    controller: _jobTitleController,
                    labelText: 'jobtitle'.tr, // Translate 'jobtitle' text
                    hintText: 'enter job title'.tr, // Translate 'enter job title' text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter job title'.tr; // Translate 'enter job title' text
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Text field for job description
                  buildTextField(
                    controller: _jobDescriptionController,
                    labelText: 'job description'.tr, // Translate 'job description' text
                    hintText: 'enter job description'.tr, // Translate 'enter job description' text
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter job description'.tr; // Translate 'enter job description' text
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Text field for company name
                  buildTextField(
                    controller: _companyNameController,
                    labelText: 'company name'.tr, // Translate 'company name' text
                    hintText: 'enter company name'.tr, // Translate 'enter company name' text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter company name'.tr; // Translate 'enter company name' text
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Text field for profile link
                  buildTextField(
                    controller: _profileLinkController,
                    labelText: 'profile link'.tr, // Translate 'profile link' text
                    hintText: 'enter profile link'.tr, // Translate 'enter profile link' text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter profile link'.tr; // Translate 'enter profile link' text
                      }
                      // Regular expression to validate URL format
                      final RegExp urlRegExp = RegExp(
                        r"^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/\S*)?$",
                      );
                      if (!urlRegExp.hasMatch(value)) {
                        return 'Please enter a valid URL'.tr; // Translate 'Please enter a valid URL' text
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Text field for salary
                  buildTextField(
                    controller: _salaryController,
                    labelText: 'salary'.tr, // Translate 'salary' text
                    hintText: 'enter salary'.tr, // Translate 'enter salary' text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter salary'.tr; // Translate 'enter salary' text
                      }
                      // Add any custom validation for salary here
                      // For example, you could check if it's a valid number
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Text field for skills
                  buildTextField(
                    controller: _skillsController,
                    labelText: 'Skills'.tr, // Translate 'Skills' text
                    hintText: 'Enter required skills (comma-separated)'.tr, // Translate 'Enter required skills (comma-separated)' text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter skills'.tr; // Translate 'Please enter skills' text
                      }
                      // Add any custom validation for skills here
                      // For example, you could check if it's a valid list of skills
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Button to post job
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _postJobToFirestore(); // Post job to Firestore if form is valid
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 85, 143, 151),
                    ),
                    child: Text(
                      'post job'.tr, // Translate 'post job' text
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(), // Display the bottom navigation bar
      ),
    );
  }

  // Widget for building a text field
  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // Function to post job data to Firestore
  void _postJobToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    String uid = user.uid;
    FirebaseAuth _auth = FirebaseAuth.instance;

    CollectionReference jobsCollection = FirebaseFirestore.instance.collection('jobsposted');

    Map<String, dynamic> jobData = {
      'jobTitle': _jobTitleController.text,
      'jobDescription': _jobDescriptionController.text,
      'companyName': _companyNameController.text,
      'profileLink': _profileLinkController.text,
      'salary': _salaryController.text,
      'skills': _skillsController.text.split(','),
      'postedBy': uid,
      'email': _auth.currentUser!.email.toString(),
      'postedDate': DateTime.now().toLocal().toString(),
    };

    try {
      await jobsCollection.add(jobData); // Add job data to Firestore

      _showSuccessMessage(context); // Show success message
      _clearTextFields(); // Clear text fields after posting job
    } catch (e) {
      print('Error posting job: $e');
    }
  }

  // Function to show a success message using SnackBar
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Job posted successfully!'.tr, // Translate 'Job posted successfully!' text
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Function to clear text fields after posting job
  void _clearTextFields() {
    _jobTitleController.clear();
    _jobDescriptionController.clear();
    _companyNameController.clear();
    _profileLinkController.clear();
    _salaryController.clear();
    _skillsController.clear();
  }
}
