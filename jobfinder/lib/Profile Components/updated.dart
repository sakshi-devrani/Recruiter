import 'package:flutter/material.dart';
import 'package:jobfinder/Profile%20Components/Logine.dart';

class Updated extends StatefulWidget {
  const Updated({super.key});

  @override
  State<Updated> createState() => _UpdatedState();
}

class _UpdatedState extends State<Updated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 210,
          ),
          Center(
              child: Text(
            "PASSWORD",
            style: TextStyle(
              fontFamily: "Merriweather",
              fontSize: 29,
            ),
          )),
          Text(
            "UPDATED",
            style: TextStyle(fontFamily: "Merriweather", fontSize: 29),
          ),
          SizedBox(
            height: 30,
          ),
          Image.asset("assets/images/updated.png"),
          SizedBox(
            height: 30,
          ),
          Text(
            "Your password has been updated!",
            style: TextStyle(color: Colors.black87),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 27, right: 27),
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 85, 143, 151),
              )),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
