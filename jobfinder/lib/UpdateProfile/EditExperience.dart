import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importing Get package
import 'package:jobfinder/formsForFirst/jobdata.dart'; // Importing job data

class EditExperience extends StatefulWidget {
  @override
  State<EditExperience> createState() => _EditExperienceState();
}

class _EditExperienceState extends State<EditExperience> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // Firebase user object
  List<Map<String, dynamic>> _experiences = []; // List to store user experiences

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the widget initializes
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      final experiencesData = await _firestore
          .collection('userdata')
          .doc(user.uid)
          .collection('experiences')
          .get();
      setState(() {
        _experiences = experiencesData.docs
            .map((doc) => doc.data())
            .toList(); // Populate _experiences list with data from Firestore
      });
    }
  }

  // Function to delete an experience from Firestore and local list
  void _deleteExperience(Map<String, dynamic> experienceToDelete) async {
    if (_user != null) {
      final userUid = _user!.uid;

      try {
        final experiencesData = await _firestore
            .collection('userdata')
            .doc(userUid)
            .collection('experiences')
            .where('companyName', isEqualTo: experienceToDelete['companyName'])
            .where('description', isEqualTo: experienceToDelete['description'])
            .get();

        if (experiencesData.docs.isNotEmpty) {
          final documentReference = experiencesData.docs.first.reference;
          await documentReference.delete(); // Delete experience from Firestore
        }

        setState(() {
          _experiences.remove(experienceToDelete); // Remove experience from local list
        });
      } catch (e) {
        print("Error deleting experience: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back button is pressed
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text(
          'Add Experience'.tr, // Add Experience title
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 228, 232, 231),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 85, 143, 151),
              )),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddExperiencePage(); // Navigate to AddExperiencePage when the button is pressed
                  },
                ));
              },
              child: Text(
                "Add Experience".tr, // Button text
                style: TextStyle(color: Colors.white),
              ),
            ),
            for (var experience in _experiences) // Iterate through each experience
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
                                    'Experience'.tr, // Experience title
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
                                        _openEditExperienceDialog(experience);
                                      },
                                      icon: Icon(Icons.edit)), // Edit icon button
                                  IconButton(
                                    icon: Icon(Icons.delete), // Delete icon button
                                    onPressed: () {
                                      _deleteExperience(experience); // Call function to delete experience
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
                                    'Company: ${experience['companyName'] ?? 'N/A'}'), // Company name
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Company Name: ${experience['companyName'] ?? 'N/A'}', // Company name
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Description: ${experience['description'] ?? 'N/A'}', // Description
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Start Date: ${experience['startDate'] ?? 'N/A'}', // Start date
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'End Date: ${experience['endDate'] ?? 'N/A'}', // End date
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Skills: ${experience['skills'] ?? 'N/A'}', // Skills
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

  // Function to open the edit experience dialog
  void _openEditExperienceDialog(Map<String, dynamic> experienceToEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditExperienceDialog(
          experienceToEdit: experienceToEdit, // Pass the experience data to the dialog
          onEditExperience: (editedExperience) {
            _editExperience(experienceToEdit, editedExperience); // Call function to edit experience
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  // Function to edit an experience
  void _editExperience(Map<String, dynamic> originalExperience,
      Map<String, dynamic> editedExperience) async {
    if (_user != null) {
      final userUid = _user!.uid;

      try {
        final experiencesData = await _firestore
            .collection('userdata')
            .doc(userUid)
            .collection('experiences')
            .where('companyName', isEqualTo: originalExperience['companyName'])
            .where('description', isEqualTo: originalExperience['description'])
            .get();

        if (experiencesData.docs.isNotEmpty) {
          final documentReference = experiencesData.docs.first.reference;
          await documentReference.update(editedExperience); // Update experience in Firestore
        }

        setState(() {
          // Update the experience in the local list
          final index = _experiences.indexOf(originalExperience);
          if (index != -1) {
            _experiences[index] = editedExperience;
          }
        });
      } catch (e) {
        print("Error editing experience: $e");
      }
    }
  }
}

// Class for the dialog to add a new experience
class AddExperienceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddExperience;

  AddExperienceDialog({required this.onAddExperience});

  @override
  _AddExperienceDialogState createState() => _AddExperienceDialogState();
}

class _AddExperienceDialogState extends State<AddExperienceDialog> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Experience".tr), // Dialog title
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _companyNameController,
              decoration: InputDecoration(labelText: "cn".tr), // Company name field
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "description".tr), // Description field
            ),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: "start date".tr), // Start date field
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: "end date".tr), // End date field
            ),
            TextField(
              controller: _skillsController,
              decoration: InputDecoration(labelText: "Skills".tr), // Skills field
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Cancel".tr), // Cancel button
        ),
        TextButton(
          onPressed: () {
            final newExperience = {
              'companyName': _companyNameController.text,
              'description': _descriptionController.text,
              'startDate': _startDateController.text,
              'endDate': _endDateController.text,
              'skills': _skillsController.text,
            };

            widget.onAddExperience(newExperience); // Call function to add experience
          },
          child: Text("add".tr), // Add button
        ),
      ],
    );
  }
}

// Class for the dialog to edit an existing experience
class EditExperienceDialog extends StatefulWidget {
  final Map<String, dynamic> experienceToEdit;
  final Function(Map<String, dynamic>) onEditExperience;

  EditExperienceDialog(
      {required this.experienceToEdit, required this.onEditExperience});

  @override
  _EditExperienceDialogState createState() => _EditExperienceDialogState();
}

class _EditExperienceDialogState extends State<EditExperienceDialog> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for editing
    _companyNameController.text = widget.experienceToEdit['companyName'];
    _descriptionController.text = widget.experienceToEdit['description'];
    _startDateController.text = widget.experienceToEdit['startDate'];
    _endDateController.text = widget.experienceToEdit['endDate'];
    _skillsController.text = widget.experienceToEdit['skills'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Experience".tr), // Dialog title
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _companyNameController,
              decoration: InputDecoration(labelText: "cn".tr), // Company name field
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "description".tr), // Description field
            ),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: "start date".tr), // Start date field
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: "end date".tr), // End date field
            ),
            TextField(
              controller: _skillsController,
              decoration: InputDecoration(labelText: "Skills".tr), // Skills field
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Cancel".tr), // Cancel button
        ),
        TextButton(
          onPressed: () {
            final editedExperience = {
              'companyName': _companyNameController.text,
              'description': _descriptionController.text,
              'startDate': _startDateController.text,
              'endDate': _endDateController.text,
              'skills': _skillsController.text,
            };

            widget.onEditExperience(editedExperience); // Call function to edit experience
          },
          child: Text("saved".tr), // Save button
        ),
      ],
    );
  }
}
