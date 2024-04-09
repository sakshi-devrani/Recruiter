import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class InterviewTipsCarousel extends StatelessWidget {
  final List<String> interviewTips = [
    "Be Prepared: Research the company and the role you are applying for.".tr,
    "Practice Common Questions: Prepare answers to common interview questions."
        .tr,
    "Dress Appropriately: Dress professionally for the interview.".tr,
    "Arrive Early: Aim to arrive 10-15 minutes early for the interview.".tr,
    "Show Enthusiasm: Show enthusiasm and interest in the role.".tr,
    "Ask Questions: Prepare questions to ask the interviewer.".tr,
    "Follow Up: Send a thank-you email after the interview.".tr,
    // Add more tips as needed
  ];

  // List of corresponding icons for each tip
  final List<IconData> tipIcons = [
    Icons.lightbulb_outline, // Example icon for the first tip
    Icons.question_answer, // Example icon for the second tip
    Icons.accessibility, // Example icon for the third tip
    Icons.timer, // Example icon for the fourth tip
    Icons.thumb_up, // Example icon for the fifth tip
    Icons.chat, // Example icon for the sixth tip
    Icons.email, // Example icon for the seventh tip
    // Add more icons as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
        backgroundColor: Colors.black,
        body: Center(
          child: CarouselSlider.builder(
            itemCount: interviewTips.length,
            options: CarouselOptions(
              height: 250, // Adjust the height as needed
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 85, 143, 151), // Change the background color
                  borderRadius:
                      BorderRadius.circular(10), // Add rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Add shadow
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Add padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tipIcons[
                              index], // Use the corresponding icon for the tip
                          color: Colors.white, // Change icon color
                          size: 40, // Adjust icon size
                        ),
                        SizedBox(height: 10), // Add spacing
                        Text(
                          interviewTips[index],
                          textAlign: TextAlign.center, // Center the text

                          style: TextStyle(
                            fontSize: 18,
                            decorationColor: Color.fromARGB(255, 85, 143, 151),
                            color: Colors.white, // Change the text color
                            fontWeight: FontWeight.bold, // Make the text bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
