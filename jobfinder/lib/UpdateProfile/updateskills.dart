import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This class represents a page where users can manage their skills
class SkillsPage extends StatefulWidget {
  @override
  _SkillsPageState createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  List<String> _userSkills = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // Fetches the current user and their skills
  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _getUserSkills(user.uid);
    }
  }

  // Fetches the skills of a specific user from Firestore
  Future<void> _getUserSkills(String uid) async {
    final userData = await _firestore.collection('userdata').doc(uid).get();
    if (userData.exists) {
      final skills = userData['skills'] as List<dynamic>;
      setState(() {
        _userSkills = skills.cast<String>();
      });
    }
  }

  // Deletes a skill from the user's skills list
  Future<void> _deleteSkill(int index) async {
    final uid = _currentUser!.uid;
    final skills = List<String>.from(_userSkills);
    skills.removeAt(index);

    await _firestore.collection('userdata').doc(uid).update({
      'skills': skills,
    });

    setState(() {
      _userSkills = skills;
    });
  }

  // Adds a new skill to the user's skills list
  Future<void> _addSkill(String newSkill) async {
    final uid = _currentUser!.uid;
    final skills = List<String>.from(_userSkills);
    skills.add(newSkill);

    await _firestore.collection('userdata').doc(uid).update({
      'skills': skills,
    });

    setState(() {
      _userSkills = skills;
    });
  }

  // Shows a dialog for adding a new skill
  void _showAddSkillDialog(BuildContext context) {
    String newSkill = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Skill'), // Dialog title
          content: TextField(
            onChanged: (value) {
              newSkill = value;
            },
            decoration: InputDecoration(labelText: 'Skill Name'), // Text field label
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'), // Cancel button
            ),
            TextButton(
              onPressed: () {
                _addSkill(newSkill); // Add skill button
                Navigator.of(context).pop();
              },
              child: Text('Add'), // Add button
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text(
          'User Skills', // App bar title
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator()) // Display loading indicator while fetching data
          : _userSkills.isEmpty
              ? Center(child: Text('No skills found.')) // Display message when no skills found
              : ListView.builder(
                  itemCount: _userSkills.length,
                  itemBuilder: (context, index) {
                    final color = Color.fromARGB(153, 85, 143, 151);
                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin:
                          EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 7),
                      child: ListTile(
                          title: Text(
                            _userSkills[index], // Display skill name
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              icon: Icon(Icons.edit), // Edit skill icon
                              onPressed: () {
                                _showEditSkillDialog(
                                    context, _userSkills[index], (newSkill) {
                                  _editSkill(index, newSkill); // Call function to edit skill
                                });
                              },
                              color: Colors.white,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete), // Delete skill icon
                              onPressed: () {
                                _deleteSkill(index); // Call function to delete skill
                              },
                              // color: Colors.white,
                            ),
                          ])),
                    );
                  },
                ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 85, 143, 151),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: InkWell(
          onTap: () {
            _showAddSkillDialog(context); // Show dialog to add a new skill
          },
          child: Text(
            'Add Skills', // Floating action button text
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  // Edits an existing skill in the user's skills list
  Future<void> _editSkill(int index, String newSkill) async {
    final uid = _currentUser!.uid;
    final skills = List<String>.from(_userSkills);
    skills[index] = newSkill;

    await _firestore.collection('userdata').doc(uid).update({
      'skills': skills,
    });

    setState(() {
      _userSkills = skills;
    });
  }

  // Shows a dialog for editing a skill
  void _showEditSkillDialog(
      BuildContext context, String oldSkill, Function(String) onEdit) {
    String newSkill = oldSkill;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Skill'), // Dialog title
          content: TextField(
            onChanged: (value) {
              newSkill = value;
            },
            controller: TextEditingController(text: oldSkill),
            decoration: InputDecoration(labelText: 'Skill Name'), // Text field label
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'), // Cancel button
            ),
            TextButton(
              onPressed: () {
                onEdit(newSkill); // Save button
                Navigator.of(context).pop();
              },
              child: Text('Save'), // Save button
            ),
          ],
        );
      },
    );
  }
}
