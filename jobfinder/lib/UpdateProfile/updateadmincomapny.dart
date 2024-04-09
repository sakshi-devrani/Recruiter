import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class represents a page where users can edit company details
class EditCompnay_details extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const EditCompnay_details({Key? key, required this.userInfo})
      : super(key: key);

  @override
  State<EditCompnay_details> createState() => _EditCompnay_detailsState();
}

class _EditCompnay_detailsState extends State<EditCompnay_details> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _locationcontroller;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user's existing information
    _companyController =
        TextEditingController(text: widget.userInfo['company']);
    _phoneController = TextEditingController(text: widget.userInfo['contact']);
    _locationcontroller =
        TextEditingController(text: widget.userInfo['location']);
    _websiteController =
        TextEditingController(text: widget.userInfo['website']);
  }

  // Function to update user data in Firestore
  void _updateUserData() async {
    final updatedData = {
      'email': widget.userInfo['email'].toString(),
      'company': _companyController.text,
      'contact': _phoneController.text,
      'location': _locationcontroller.text,
      'website': _websiteController.text,
    };

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userUid = user.uid;
        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection('admin')
            .doc(userUid)
            .update(updatedData);
      }

      // Pass the updated data back to the previous screen
      Navigator.of(context).pop(
          updatedData); // Pass updated data back when the user taps "Update"
    } catch (e) {
      print('Error updating user data: $e');
      // Handle the error as needed (e.g., show a snackbar or alert dialog)
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
        backgroundColor: const Color.fromARGB(255, 85, 143, 151),
        title: Text(
          'Update Information', // App bar title
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Email:"), // Static text
              SizedBox(
                height: 5,
              ),
              Text(widget.userInfo['email'].toString()), // Display user's email
              Divider(
                color: Colors.black54,
              ),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Name'), // Text field for company name
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name'; // Validation error message
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Contact No'), // Text field for contact number
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number'; // Validation error message
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Phone number must contain only digits'; // Validation error message
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationcontroller,
                decoration: InputDecoration(labelText: 'Location'), // Text field for location
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode'; // Validation error message
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website'), // Text field for website
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your website URL'; // Validation error message
                  } else if (!_isValidUrl(value)) {
                    return 'Invalid website URL'; // Validation error message
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 85, 143, 151),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, submit the data
                    _updateUserData();
                    _submitForm();
                  }
                },
                child: Text(
                  'Update', // Button text
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, handle the form submission here
      // For simplicity, just show a snackbar for demonstration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updating information...'), // SnackBar message
          duration: Duration(seconds: 2),
        ),
      );

      // Simulate an update process
      Future.delayed(Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Information updated successfully'), // SnackBar message
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  // Function to check if a URL is valid
  bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }
}
