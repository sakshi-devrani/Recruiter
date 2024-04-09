import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/Logine.dart';
import 'package:jobfinder/helper/uiHelper.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
                child: Image.asset(
              "assets/images/lock.png",
              height: 100,
            )),
            SizedBox(
              height: 30,
            ),
            Text(
              "FORGET".tr,
              style: TextStyle(fontSize: 28, fontFamily: "Merriweather"),
            ),
            Text(
              "PASSWORD".tr,
              style: TextStyle(fontSize: 28, fontFamily: "Merriweather"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Provide your accounts email for which you want to reset your passeord!"
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
            // const Padding(
            //   padding: EdgeInsets.only(left: 55, top: 15),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Forget Password",
            //       style: TextStyle(
            //           color: Color.fromARGB(255, 85, 143, 151),
            //           fontSize: 40,
            //           fontFamily: "GreatVibes-Regular"),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 13,
            ),
            Text(
              "Email".tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email), border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => validateTextBox(),
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                      Color.fromARGB(255, 85, 143, 151),
                    ),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                    padding: const MaterialStatePropertyAll(EdgeInsets.only(
                        left: 60, right: 60, bottom: 10, top: 10))),
                child: Text(
                  "Reset Password".tr,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateTextBox() {
    if (_emailController.text.isEmpty) {
      UiHelper.showSnackbar(context, "Please enter an email address".tr);
    } else if (!isValidEmail(_emailController.text)) {
      UiHelper.showSnackbar(context, "Invalid email address".tr);
    } else {
      _sendResetEmail();
    }
  }

  void _sendResetEmail() {
    _auth.sendPasswordResetEmail(email: _emailController.text).then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }
}

bool isValidEmail(String email) {
  // Regular expression for a simple email validation
  String emailRegex = r'^[a-zA-Z_]+[\w-]*@(gmail\.)+[com]';
  RegExp regex = RegExp(emailRegex);
  return regex.hasMatch(email);
}
