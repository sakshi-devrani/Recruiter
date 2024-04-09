import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:jobfinder/helper/uiHelper.dart';

// ApplicationFormPage is a StatefulWidget which represents the application form page
class ApplicationFormPage extends StatefulWidget {
  final String jobId;
  final User? currentUser;
  final String jobtitle;
  final String jobemail;

  ApplicationFormPage({
    required this.jobId,
    required this.currentUser,
    required this.jobtitle,
    required this.jobemail,
  });

  @override
  _ApplicationFormPageState createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for handling input fields
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _salaryExpectationController =
      TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedFile;
  bool _check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apply for Job',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assigning form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why should I hire you?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(
                    hintText: 'Years of experience...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter years of experience';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Have you worked on any projects?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _projectController,
                  decoration: const InputDecoration(
                    hintText: 'Enter project details...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Salary Expectation',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _salaryExpectationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your salary expectation...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your salary expectation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Are you available immediately?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _availabilityController,
                  decoration: const InputDecoration(
                    hintText: 'Yes or No',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide your availability';
                    }
                    return null;
                  },
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Upload your resume",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: _pickPDF,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 11,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _check
                            ? Row(
                                children: [
                                  const Text(
                                    "Uploaded Successfully",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      _check = false;
                                      _pickedFile = null;
                                    }),
                                    icon: const Icon(
                                      CupertinoIcons.clear_thick_circled,
                                    ),
                                  )
                                ],
                              )
                            : const Row(
                                children: [
                                  Icon(
                                    Icons.upload_sharp,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Upload file",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Add your file upload widget here
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 85, 143, 151),
                  ),
                  child: const Text(
                    'Submit Application',
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
    );
  }

  // Function to send email with application details
  void sendEmail() async {
    String body = _availabilityController.text;

    final Email email = Email(
      body: body,
      subject: widget.jobtitle,
      recipients: [widget.jobemail],
      attachmentPaths: [_pickedFile!.path],
      isHTML: false,
    );
    await FlutterEmailSender.send(email).then((value) {
      UiHelper.showSnackbar(context, "Application Submitted");
      Navigator.pushReplacementNamed(context, '/JobFinderHomeScreen');
    });
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is validated, proceed with form submission logic
      String experience = _experienceController.text;
      String projectDetails = _projectController.text;
      String salaryExpectation = _salaryExpectationController.text;
      String availability = _availabilityController.text;
      sendEmail(); // Sending email with application details

      // Perform the submission logic here, for example:
      submitApplication(
        experience,
        projectDetails,
        salaryExpectation,
        availability,
      );
    }
  }

  // Function to submit application details to Firestore
  void submitApplication(
    String experience,
    String projectDetails,
    String salaryExpectation,
    String availability,
  ) {
    String userUid = widget.currentUser?.uid ?? '';
    FirebaseFirestore.instance
        .collection('jobsposted')
        .doc(widget.jobId)
        .collection('applications')
        .doc(userUid)
        .set({
      'experience': experience,
      'projects': projectDetails,
      'salaryExpectation': salaryExpectation,
      'availability': availability,
      'email': _auth.currentUser!.email.toString(),
    }).then((_) {
      print('Application submitted for jobId: ${widget.jobId}');
      print('User UID: $userUid');
      print('Experience: $experience');
      print('Projects: $projectDetails');
      print('Salary Expectation: $salaryExpectation');
      print('Availability: $availability');
      Navigator.pop(context, true); // Navigate back to previous screen
    }).catchError((error) {
      print('Error submitting application: $error');
      // Handle error
    });
  }

  // Function to pick a PDF file
  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // Store the picked PDF file in the variable
      _pickedFile = File(result.files.first.path!);

      setState(() {
        _check = true;
      });

      // Handle other aspects if needed, e.g., displaying the file name
      print('File picked: ${result.files.first.name}');
    } else {
      UiHelper.showSnackbar(context, "Choose Again");
    }
  }
}
