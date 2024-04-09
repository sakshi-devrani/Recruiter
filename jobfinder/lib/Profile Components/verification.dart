import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/Profile%20Components/credentials.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sp;
User? user;
FirebaseAuth? auth; // Firebase Authentication object for OTP

class Verification extends StatefulWidget {
  final String phone;

  Verification(this.phone);
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isVerified = false;
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  int otpbtn = 0;
  String vc = "";

  TextEditingController otp = TextEditingController();

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
            Icons.close,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 0,
            ),
            Text(
              "CO",
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900),
            ),
            Text(
              "DE",
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900),
            ),
            Text(
              "VERIFICATION",
              style: TextStyle(fontFamily: "Merriweather", fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Enter one time password sent on ",
              style: TextStyle(color: Colors.black87),
            ),
            Container(
              child: Center(
                child: Text(
                  '+91 -${widget.phone}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                controller: _pinPutController,
                pinAnimationType: PinAnimationType.fade,
                onTap: () {},
                onSubmitted: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode!, smsCode: pin))
                        .then((value) async {});
                    if (_isVerified) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Credentials()),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to verify phone number using OTP
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 ${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Credentials()),
                (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String? verficationID, int? resendToken) {
        setState(() {
          _verificationCode = verficationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Resend OTP logic goes here
        _verificationCode = verificationId;
      },
      timeout: const Duration(seconds: 120),
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone(); // Start phone number verification process when the widget initializes
  }
}
