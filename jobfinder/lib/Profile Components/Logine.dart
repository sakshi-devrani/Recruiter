// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/Help.dart';
import 'package:jobfinder/Profile%20Components/nav_infor/forget_password.dart';
import 'package:jobfinder/Profile%20Components/signup.dart';
import 'package:jobfinder/user_admin/user_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Initialize global variables
User? user; // Firebase user object
SharedPreferences? sp; // Shared preferences object
FirebaseAuth? auth; // Firebase authentication object

// LoginPage StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// _LoginPageState State class
class _LoginPageState extends State<LoginPage> {
  // Global key for managing the login form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for email and password text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // State variables
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  "assets/logoo.png",
                  height: 100,
                ),
              ),
              // Display title text
              Text(
                "title".tr,
                style: TextStyle(
                  color: Color.fromARGB(255, 85, 143, 151),
                  fontSize: 60,
                ),
              ),
              // Display greeting text
              Text(
                "Hello".tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              const SizedBox(
                height: 5,
              ),
              // Display login prompt text
              Text(
                "Sign into your Account".tr,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
              ),
              const SizedBox(
                height: 20,
              ),
              // Login form fields
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // Email text field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email*".tr,
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
                          return 'Please enter an email address'.tr;
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Invalid email address'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Password text field
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Password*".tr,
                        hintStyle: const TextStyle(color: Colors.grey),
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
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      cursorColor: Colors.grey,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Forgot password link
                    Container(
                      margin: const EdgeInsets.only(left: 200),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const ForgetPassword();
                            },
                          ));
                        },
                        child: Text(
                          "Forgot Password?".tr,
                          style: TextStyle(
                              color: Color.fromARGB(255, 202, 46, 35)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // Login button
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  // Navigate to the homepage upon successful login
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const User_admin(),
                                    ),
                                  );
                                } catch (e) {
                                  // Handle login errors here
                                  String errorMessage =
                                      "An error occurred. Please check your credentials.";
                                  if (e is FirebaseAuthException) {
                                    if (e.code == 'user-not-found') {
                                      errorMessage =
                                          "No user found with that email.";
                                    } else if (e.code == 'wrong-password') {
                                      errorMessage =
                                          "Wrong password. Please try again.";
                                    }
                                  }
                                  _showErrorDialog(context, errorMessage);
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                      child: Text(
                        "Login".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 85, 143, 151),
                          ),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.only(
                                  left: 90, right: 90, bottom: 15, top: 15))),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Login with Google option
                    Text(
                      "Or login with Google".tr,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        FirebaseService service = FirebaseService();
                        await service.signInwithGoogle();
                        user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const User_admin()));
                        }
                      },
                      child: Container(
                        child: Image.asset(
                          "assets/images/google.png",
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Help link
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Help(),
                    ),
                  );
                },
                child: Text(
                  'help'.tr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 60, 74),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Registration link
              Container(
                height: 50,
                color: const Color.fromARGB(36, 158, 158, 158),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?".tr),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SignupPage();
                          },
                        ));
                      },
                      child: Text(
                        " Register Now".tr,
                        style: TextStyle(
                            color: Color.fromARGB(255, 85, 143, 151),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

// Function to display error dialog
void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// FirebaseService class for handling Firebase authentication with Google
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Function to sign in with Google
  Future<String?> signInwithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await _auth.signInWithCredential(credential);
    return null;
  }

  // Function to sign out from Google
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
