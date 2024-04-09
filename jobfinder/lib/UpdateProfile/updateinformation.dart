import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// This class represents a page where users can update their information
class UpdateInformationPage extends StatefulWidget {
  final Map<String, dynamic> userInfo; // User information to be updated

  const UpdateInformationPage({Key? key, required this.userInfo})
      : super(key: key);

  @override
  _UpdateInformationPageState createState() => _UpdateInformationPageState();
}

class _UpdateInformationPageState extends State<UpdateInformationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user's existing information
    _nameController = TextEditingController(text: widget.userInfo['name']);
    _emailController = TextEditingController(text: widget.userInfo['email']);
    _phoneController = TextEditingController(text: widget.userInfo['phone']);
    _cityController =
        TextEditingController(text: widget.userInfo['address']['city']);
    _countryController =
        TextEditingController(text: widget.userInfo['address']['country']);
    _pincodeController =
        TextEditingController(text: widget.userInfo['address']['pincode']);
  }

  // Function to update user data in Firestore
  void _updateUserData() async {
    final updatedData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': {
        'city': _cityController.text,
        'country': _countryController.text,
        'pincode': _pincodeController.text,
      },
    };

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userUid = user.uid;
        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection('userdata')
            .doc(userUid)
            .update(updatedData);
      }

      // Pass the updated data back to the previous screen
      Navigator.of(context).pop(updatedData); // Pass updated data back when the user taps "Update"
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
          'Update Information'.tr, // Internationalized text
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'name'.tr), // Internationalized text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name'.tr; // Internationalized text
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email", // Static text
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Text(widget.userInfo['email'].toString()), // Display user's email
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black45,
                thickness: 1,
              ),
              TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'phone'.tr), // Internationalized text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number'.tr; // Internationalized text
                  }
                  // Add more validation rules for phone number if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'city'.tr), // Internationalized text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city'.tr; // Internationalized text
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'country'.tr), // Internationalized text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country'.tr; // Internationalized text
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                controller: _pincodeController,
                decoration: InputDecoration(labelText: 'pincode'.tr), // Internationalized text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode'.tr; // Internationalized text
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                  const Color.fromARGB(255, 85, 143, 151),
                )),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, submit the data
                    _updateUserData();
                    _submitForm();
                  }
                },
                child: Text(
                  'update'.tr, // Internationalized text
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
          content: Text('Updating information...'.tr), // Internationalized text
          duration: Duration(seconds: 2),
        ),
      );

      // Simulate an update process
      Future.delayed(Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Information updated successfully'.tr), // Internationalized text
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }
}
