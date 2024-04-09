// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/updated.dart';

class Credentials extends StatefulWidget {
  const Credentials({Key? key}) : super(key: key);

  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;

  bool _passwordVisible2 = false;

  final _formKey = GlobalKey<FormState>(); // Key for Form validation

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show a success message or navigate to a success screen
    } catch (e) {
      // Handle errors here
      print("Error sending password reset email: $e".tr);
    }
  }

  Future<void> _updatePasswordAndEmail(String email, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Prompt the user to reauthenticate
        var credential = EmailAuthProvider.credential(
            email: email, password: _passwordController.text);
        await user.reauthenticateWithCredential(credential);
        print("User reauthenticated successfully.".tr);

        // Update password
        await user.updatePassword(newPassword);
        print("Password updated successfully.".tr);

        // Save email to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'email': email}, SetOptions(merge: true));
        print("Email saved to Firestore successfully.".tr);

        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Updated()),
        );
      }
    } catch (e) {
      // Handle errors here
      print("Error updating password and email: $e".tr);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error".tr),
            content:
                Text("Failed to update password and email. Please try again.".tr),
            actions: <Widget>[
              TextButton(
                child: Text("OK".tr),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Form key for validation
          child: Column(
            children: [
              Center(
                child: Image.asset("assets/images/credentials.png"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "NEW".tr,
                style: TextStyle(fontFamily: "Merriweather", fontSize: 25),
              ),
              Text(
                "CREDENTIALS".tr,
                style: TextStyle(fontFamily: "Merriweather", fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your identity has been verified! \n      Set your New password".tr,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 27, right: 27, bottom: 10, top: 10),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email".tr,
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: Icon(Icons.email),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 27, right: 27, bottom: 10, top: 10),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password'.tr;
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long'.tr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: "New Password*".tr,
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  cursorColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 27, right: 27, bottom: 10, top: 10),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password'.tr;
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match'.tr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_passwordVisible2,
                  decoration: InputDecoration(
                    hintText: "Confirm Password*".tr,
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible2 = !_passwordVisible2;
                        });
                      },
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  cursorColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.only(
                      left: 100, right: 100, top: 15, bottom: 15)),
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 85, 143, 151),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _updatePasswordAndEmail(
                        _emailController.text, _passwordController.text);
                  }
                },
                child: Text(
                  'NEXT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
