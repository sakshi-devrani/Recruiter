import 'package:flutter/material.dart';
import 'package:jobfinder/Profile%20Components/verification.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

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
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
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
                  "FORGET",
                  style: TextStyle(fontSize: 28, fontFamily: "Merriweather"),
                ),
                Text(
                  "PASSWORD",
                  style: TextStyle(fontSize: 28, fontFamily: "Merriweather"),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Provide your account's email for which you want\n                     to reset your passeord!",
                  style: TextStyle(color: Colors.black87),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('+91'),
                      ),
                    ),
                    maxLength: 10, // including prefix (+91)
                    keyboardType: TextInputType.phone,
                    controller: _controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 85, 143, 151),
                    )),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Verification(_controller.text),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'NEXT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
