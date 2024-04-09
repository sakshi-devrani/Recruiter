import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:jobfinder/Profile%20Components/Logine.dart';
import 'package:jobfinder/Profile%20Components/signup.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool r1 = false;
  bool r2 = false;
  bool r3 = false;
  final List<String> imageUrls = [
    'assets/images/wc1.jpg',
    'assets/images/wc2.jpg',
    'assets/images/wc3.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Image.network(
          //     "https://img.freepik.com/premium-vector/modern-coffee-shop-with-furniture_122154-706.jpg?w=2000"),
          CarouselSlider(
            options: CarouselOptions(
              height: 450,
              autoPlay: true,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
            ),
            items: imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image.asset(
                      url,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "title".tr,
            style: TextStyle(
                fontSize: 87,
                color: Color.fromARGB(255, 10, 130, 138),
                fontWeight: FontWeight.w400,
                fontFamily: "GreatVibes-Regular"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "GET YOUR DREAM JOB".tr,
            style: TextStyle(
                fontSize: 18,
                fontFamily: "JosefinSlab",
                fontWeight: FontWeight.bold),
          ),

          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome".tr,
            style: TextStyle(fontSize: 29, fontFamily: "HennyPenny"),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    r1 = !r1;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SignupPage();
                      },
                    ));
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 10, 130, 138),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Register'.tr,
                    style: TextStyle(
                      color: Color.fromARGB(255, 10, 130, 138),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    r2 = !r2;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ));
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 10, 130, 138),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Login'.tr,
                    style: TextStyle(
                      color: Color.fromARGB(255, 10, 130, 138),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

//include: package:flutter_lints/flutter.yaml