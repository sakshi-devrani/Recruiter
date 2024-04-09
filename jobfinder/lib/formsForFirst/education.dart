import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jobfinder/user/profile.dart';

class AddEducationPage extends StatefulWidget {
  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _educontroller = TextEditingController();
  final TextEditingController _eduunicontroller = TextEditingController();
  final TextEditingController _educomcontroller = TextEditingController();
  final TextEditingController _educourcecontroller = TextEditingController();
  final TextEditingController _cgpacontroller = TextEditingController();

  String _message = '';

  // Function to add education details to Firestore
  Future<void> _addEducation() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final uid = user.uid;
      final educationDetails = {
        'educationType': _educontroller.text,
        'college': _eduunicontroller.text,
        'completion': _educomcontroller.text,
        'course': _educourcecontroller.text,
        'cgpa': _cgpacontroller.text,
        'Resume': ""
      };
      // Adding education details to Firestore
      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(uid)
          .collection('Educations')
          .add(educationDetails);

      // Updating 'formdone' field in user's document to indicate completion
      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(uid)
          .update({'formdone': 0});

      setState(() {
        _message = 'Data added successfully';
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
          'add education'.tr, // Translate 'add education' text
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 60, 74),
      ),
      backgroundColor: Color.fromARGB(255, 134, 160, 166),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _educontroller,
                    decoration: InputDecoration(
                      labelText: 'education type'.tr, // Translate 'education type' text
                      icon: Icon(
                        Icons.school_outlined,
                        color: const Color.fromARGB(255, 6, 60, 74),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a Education Type'.tr; // Translate validation error message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _eduunicontroller,
                    decoration: InputDecoration(
                      labelText: 'college and univercity'.tr, // Translate 'college and university' text
                      icon: Icon(
                        Icons.home_work_outlined,
                        color: const Color.fromARGB(255, 6, 60, 74),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a college and university'.tr; // Translate validation error message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _educomcontroller,
                    decoration: InputDecoration(
                      labelText: 'completion'.tr, // Translate 'completion' text
                      icon: Icon(
                        Icons.calendar_month,
                        color: const Color.fromARGB(255, 6, 60, 74),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an Completion date'.tr; // Translate validation error message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cgpacontroller,
                    decoration: InputDecoration(
                      labelText: 'cgpa'.tr, // Translate 'cgpa' text
                      icon: Icon(
                        Icons.copyright_sharp,
                        color: const Color.fromARGB(255, 6, 60, 74),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter cgpa'.tr; // Translate validation error message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 169, 186, 190),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _addEducation();
                      }
                    },
                    child: Text(
                      'add education'.tr, // Translate 'add education' button text
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 60, 74),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0), backgroundColor: const Color.fromARGB(255, 6, 60, 74),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => User_profile(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'done'.tr, // Translate 'done' button text
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class temppage extends StatefulWidget {
  const temppage({super.key});

  @override
  State<temppage> createState() => _temppageState();
}

class _temppageState extends State<temppage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
