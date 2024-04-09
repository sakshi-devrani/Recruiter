// Import necessary packages and files
// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// EditEducation widget for editing user's education information
class EditEducation extends StatefulWidget {
  const EditEducation({Key? key});

  @override
  State<EditEducation> createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // User object
  List<Map<String, dynamic>> _education = []; // List to store education data as maps
  List<DocumentReference> _education2 = []; // List to store education document references

  @override
  void initState() {
    super.initState();
    _getUserData(); // Get user's education data
  }

  // Fetch user's education data from Firestore
  Future<void> _getUserData() async {
    final user = _auth.currentUser; // Get current user
    if (user != null) {
      setState(() {
        _user = user;
      });

      final educationData = await _firestore
          .collection('userdata')
          .doc(user.uid)
          .collection('Educations')
          .get(); // Get user's education documents
      _education2 = educationData.docs.map((doc) => doc.reference).toList(); // Get education document references

      setState(() {
        _education = educationData.docs
            .map((doc) => doc.data())
            .toList(); // Convert education documents to list of maps
      });
    }
  }

  // Function to open dialog for adding new education
  void _openAddEducationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEducationDialog(
          onAddExperience: (newEducation) {
            _addEducation(newEducation); // Add new education
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Function to add new education to Firestore
  void _addEducation(Map<String, dynamic> newEducation) async {
    if (_user != null) {
      final userUid = _user!.uid;

      await _firestore
          .collection('userdata')
          .doc(userUid)
          .collection('Educations')
          .add(newEducation); // Add new education document

      setState(() {
        _education.add(newEducation); // Update education list
      });
    }
  }

  // Function to delete education from Firestore
  void _deleteEducation(Map<String, dynamic> educationToDelete) async {
    if (_user != null) {
      final userUid = _user!.uid;

      try {
        final educationsData = await _firestore
            .collection('userdata')
            .doc(userUid)
            .collection('Educations')
            .where('educationType',
                isEqualTo: educationToDelete['educationType'])
            .where('college', isEqualTo: educationToDelete['college'])
            .get(); // Get education documents to delete

        if (educationsData.docs.isNotEmpty) {
          final documentReference = educationsData.docs.first.reference;
          await documentReference.delete(); // Delete education document
        }

        setState(() {
          _education.remove(educationToDelete); // Update education list
        });
      } catch (e) {
        print("Error deleting education: $e");
      }
    }
  }

  // Function to open dialog for editing education
  void _openEditEducationDialog(Map<String, dynamic> educationToEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditEducationDialog(
          educationToEdit: educationToEdit,
          onEditEducation: (editedEducation) {
            _editEducation(educationToEdit, editedEducation); // Edit education
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Function to edit education in Firestore
  void _editEducation(Map<String, dynamic> editedEducation,
      Map<String, dynamic> originalEducation) async {
    if (_user != null) {
      final userUid = _user!.uid;

      try {
        final educationsData = await _firestore
            .collection('userdata')
            .doc(userUid)
            .collection('Educations')
            .where('educationType',
                isEqualTo: originalEducation['educationType'])
            .where('college', isEqualTo: originalEducation['college'])
            .get(); // Get education documents to edit

        if (educationsData.docs.isNotEmpty) {
          final documentReference = educationsData.docs.first.reference;
          await documentReference.update(editedEducation); // Update education document
        }

        setState(() {
          final index = _education.indexOf(originalEducation);

          _education[index] = editedEducation; // Update education list
        });
      } catch (e) {
        print("Error editing education: $e");
      }
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
            )),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text(
          'Edit Education'.tr, // Translated title
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 228, 232, 231),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 85, 143, 151),
                ),
              ),
              onPressed: () {
                _openAddEducationDialog(); // Open dialog to add education
              },
              child: Text(
                "Add Education", // Button text
                style: TextStyle(color: Colors.white),
              ),
            ),
            for (var Educations in _education)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(16),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    'education'.tr, // Translated education text
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 95,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _openEditEducationDialog(Educations); // Open dialog to edit education
                                    },
                                    icon: Icon(Icons.edit), // Edit icon
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteEducation(Educations); // Delete education
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ListTile(
                                leading: Icon(
                                  Icons.work,
                                  color: Colors.amber,
                                ),
                                title: Text(
                                    'Education: ${Educations['educationType'] ?? 'N/A'}'), // Display education type
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'college ${Educations['college'] ?? 'N/A'}'
                                          .tr, // Translated college text
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Completion: ${Educations['completion'] ?? 'N/A'}', // Display completion
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Course: ${Educations['course'] ?? 'N/A'}', // Display course
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'CGPA: ${Educations['cgpa'] ?? 'N/A'}', // Display CGPA
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// AddEducationDialog for adding new education
class AddEducationDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddExperience;

  AddEducationDialog({required this.onAddExperience});

  @override
  _AddEducationDialogState createState() => _AddEducationDialogState();
}

class _AddEducationDialogState extends State<AddEducationDialog> {
  final TextEditingController _educationTypeController =
      TextEditingController();
  final TextEditingController _collegeuniversityController =
      TextEditingController();
  final TextEditingController _completionController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Education".tr), // Translated dialog title
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _educationTypeController,
              decoration: InputDecoration(labelText: "education".tr), // Translated education label
            ),
            TextField(
              controller: _collegeuniversityController,
              decoration: InputDecoration(labelText: "college".tr), // Translated college label
            ),
            TextField(
              controller: _completionController,
              decoration: InputDecoration(labelText: "completion".tr), // Translated completion label
            ),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: "course".tr), // Translated course label
            ),
            TextField(
              controller: _cgpaController,
              decoration: InputDecoration(labelText: "cgpa".tr), // Translated cgpa label
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel".tr), // Translated cancel button text
        ),
        TextButton(
          onPressed: () {
            final newEducation = {
              'educationType': _educationTypeController.text,
              'college': _collegeuniversityController.text,
              'completion': _completionController.text,
              'course': _courseController.text,
              'cgpa': _cgpaController.text,
            };

            widget.onAddExperience(newEducation); // Add new education
          },
          child: Text("add".tr), // Translated add button text
        ),
      ],
    );
  }
}

// EditEducationDialog for editing education
class EditEducationDialog extends StatefulWidget {
  final Map<String, dynamic> educationToEdit;
  final Function(Map<String, dynamic>) onEditEducation;

  EditEducationDialog(
      {required this.educationToEdit, required this.onEditEducation});

  @override
  _EditEducationDialogState createState() => _EditEducationDialogState();
}

class _EditEducationDialogState extends State<EditEducationDialog> {
  final TextEditingController _educationTypeController =
      TextEditingController();
  final TextEditingController _collegeuniversityController =
      TextEditingController();
  final TextEditingController _completionController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for editing
    _educationTypeController.text = widget.educationToEdit['educationType'];
    _collegeuniversityController.text = widget.educationToEdit['college'];
    _completionController.text = widget.educationToEdit['completion'];
    _courseController.text = widget.educationToEdit['course'];
    _cgpaController.text = widget.educationToEdit['cgpa'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Education".tr), // Translated dialog title
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _educationTypeController,
              decoration: InputDecoration(labelText: "education".tr), // Translated education label
            ),
            TextField(
              controller: _collegeuniversityController,
              decoration: InputDecoration(labelText: "college".tr), // Translated college label
            ),
            TextField(
              controller: _completionController,
              decoration: InputDecoration(labelText: "completion".tr), // Translated completion label
            ),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: "course".tr), // Translated course label
            ),
            TextField(
              controller: _cgpaController,
              decoration: InputDecoration(labelText: "cgpa".tr), // Translated cgpa label
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel".tr), // Translated cancel button text
        ),
        TextButton(
          onPressed: () {
            final editedEducation = {
              'educationType': _educationTypeController.text,
              'college': _collegeuniversityController.text,
              'completion': _completionController.text,
              'course': _courseController.text,
              'cgpa': _cgpaController.text,
            };

            widget.onEditEducation(editedEducation); // Edit education
          },
          child: Text("save".tr), // Translated save button text
        ),
      ],
    );
  }
}
