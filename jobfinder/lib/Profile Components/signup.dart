import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/Help.dart';
import 'package:jobfinder/Profile%20Components/Logine.dart'; // Import necessary files
import 'package:jobfinder/Profile%20Components/nav_infor/Privacy_Policy.dart';
import 'package:jobfinder/services/registerWithEmailAndPassword.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey for the form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false; // State variable to control loading state
  bool isChecked = false; // State variable to track checkbox state

  bool _obscureText = true; // State variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              children: [
                // Logo and title
                SizedBox(
                  height: 45,
                ),
                Center(
                  child: Image.asset(
                    "assets/logoo.png",
                    height: 100,
                  ),
                ),
                Text(
                  "title".tr, // Placeholder text, might be translated text
                  style: TextStyle(
                    color: Color.fromARGB(255, 85, 143, 151),
                    fontSize: 60,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Hello".tr, // Placeholder text, might be translated text
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sigup into your Account".tr, // Placeholder text, might be translated text
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
                ),
                SizedBox(
                  height: 20,
                ),
                // Form inputs
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      // Email input field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email*".tr, // Placeholder text, might be translated text
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        cursorColor: Colors.grey,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address'.tr; // Validation message, might be translated text
                          } else {
                            // Regular expression for strong email validation
                            String pattern = r'^[a-z0-9._%+-]+@gmail\.com$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email address'.tr; // Validation message, might be translated text
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Password input field
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "Password*".tr, // Placeholder text, might be translated text
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        cursorColor: Colors.grey,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 8 || value.length > 12) {
                            return 'Password must be between 8 and 12 characters';
                          } else if (!RegExp(
                                  r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:<>?/~`[\]\\-])')
                              .hasMatch(value)) {
                            return 'Password must contain at least one letter, one number, and one special character';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Phone number input field
                      TextFormField(
                        maxLength: 10,
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Phone Number'.tr), // Placeholder text, might be translated text
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number'.tr; // Validation message, might be translated text
                          } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Phone number must contain only digits'.tr; // Validation message, might be translated text
                          } else if (value.length != 10) {
                            return 'Phone number must be 10 digits'.tr; // Validation message, might be translated text
                          }
                          return null;
                        },
                      ),
                      // Checkbox for terms and conditions
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 85, 143, 151),
                            ),
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          Text(
                            "I Read and agree to".tr, // Placeholder text, might be translated text
                            style: TextStyle(color: Colors.black26),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Privacy_Policy();
                                },
                              ));
                              // Open Terms & Conditions page or show details
                            },
                            child: Text(
                              "Terms & Conditions".tr, // Placeholder text, might be translated text
                              style: TextStyle(
                                color: Color.fromARGB(255, 85, 143, 151),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Register button
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                _submitForm();
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    await registerWithEmailAndPassword(
                                      _emailController.text,
                                      _phoneNumberController.text,
                                    );

                                    // Navigate to the login page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  } catch (e) {
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 85, 143, 151),
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.only(
                                    left: 90, right: 90, bottom: 15, top: 15))),
                        child: Text(
                          'Register'.tr, // Placeholder text, might be translated text
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Help link
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Help(),
                            ),
                          );
                        },
                        child: Text(
                          'help'.tr, // Placeholder text, might be translated text
                          style: TextStyle(
                            color: Color.fromARGB(255, 6, 60, 74),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Login link
                Container(
                  height: 50,
                  color: Color.fromARGB(36, 158, 158, 158),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?".tr), // Placeholder text, might be translated text
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ));
                        },
                        child: Text(
                          "Login".tr, // Placeholder text, might be translated text
                          style: TextStyle(
                              color: Color.fromARGB(255, 85, 143, 151),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!isChecked) {
      // Show snackbar if checkbox is not checked
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to the Terms & Conditions.'), // Snackbar text, might be translated text
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop form submission if checkbox is not checked
    }

    // Proceed with form submission logic here
  }
}
