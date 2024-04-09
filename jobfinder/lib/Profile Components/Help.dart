import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool _newUser = false;
  bool _existingUser = false;

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
          "Help Page".tr,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Login & Registration Guide".tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(79, 194, 234, 239),
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Welcome to Our Talent Hub!".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 19),
                      )),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "🌟 Why Register? 🌟".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      )),
                  SizedBox(
                    height: 7,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Unlock exclusive access to top talent.\nConnect with skilled professionals.\nDiscover your next star hire"
                            .tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w200, fontSize: 19),
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _newUser
                        ? setState(() {
                            _newUser = false;
                          })
                        : setState(() {
                            _newUser = true;
                          });
                    setState(() {
                      _existingUser = false;
                    });
                    print("New User");
                    print(_newUser);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    height: MediaQuery.of(context).size.height / 8,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(82, 194, 234, 239),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "1. New User Registration:".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "Click here".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color.fromARGB(255, 85, 143, 151),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _existingUser
                        ? setState(() {
                            _existingUser = false;
                          })
                        : setState(() {
                            _existingUser = true;
                          });
                    setState(() {
                      _newUser = false;
                    });

                    print(_existingUser);
                    print("Existing User");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    height: MediaQuery.of(context).size.height / 8,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(82, 194, 234, 239),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "2. Existing User Login:".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "Click here".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color.fromARGB(255, 85, 143, 151),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _newUser ? true : false,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(82, 194, 234, 239),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "New User Registration".tr,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Center(
                        child: Text(
                          "Registration Steps:".tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Email Address:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Provide a valid email address.\nThis will be your unique username for login.\nDouble-check for accuracy."
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Create a Password:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Provide your secret key to unlock your recruiter dashboard.\nRemember, security matters! Use a strong password.\nMix uppercase, lowercase, numbers, and special characters.\nAvoid using easily guessable information (like “password123”)."
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Phone Number:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Add your contact digits.\nWe promise not to spam you (unless it’s about job opportunities)."
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Terms and Conditions:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Read the fine print (yes, we know it’s long).\nAccept our virtual handshake.\nWe’re in this together!"
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Register Button:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Click to create your recruiter account.\nCongratulations! You’re now part of our recruiter family."
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
            ),
          ),
          Visibility(
            visible: _existingUser ? true : false,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(82, 194, 234, 239),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Existing User Login".tr,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                      Center(
                          child: Text(
                        "Welcome Back!".tr,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        "Username or Email:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Enter your registered email address or username.\nIf you’ve forgotten your username, use your email.\nDouble-check for typos!"
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Password:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Provide your secret key to unlock your recruiter dashboard.\nRemember, security matters! Use a strong password.\nMix uppercase, lowercase, numbers, and special characters.\nAvoid using easily guessable information (like “password123”)."
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Forgot Password?:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Click the link if memory fails you.\nWe’ll send a OTP to your registered Phone Number.\nyou will get the OTP to Update your Password.\nNew page will appear for you to set your new paassword."
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Login Button:".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Click to access your recruiter account.\nWelcome back to the world of talent acquisition!"
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Questions or Assistance?".tr,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Our support team is here for you.\nReach out if you need help"
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "recruiter@gmail.com"
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "+91 90998-77839 "
                            .tr,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      )),
    );
  }
}
