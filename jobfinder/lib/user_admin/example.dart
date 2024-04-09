import 'package:flutter/material.dart';
import 'package:jobfinder/UpdateProfile/UpdateEducation.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  // List to hold education data
  List<Map<String, dynamic>> _education = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Stack(
          children: <Widget>[
            Container(
              width: 400,
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Title for education section
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Educations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Displaying education details using ListTiles
                        for (var Educations in _education)
                          ListTile(
                            leading: const Icon(
                              Icons.school,
                              color: Color.fromARGB(255, 85, 143, 151),
                            ),
                            title: Text(
                                'Education: ${Educations['educationType'] ?? 'N/A'}'), // Displaying education type
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'College/University: ${Educations['college'] ?? 'N/A'}', // Displaying college/university
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Completion: ${Educations['completion'] ?? 'N/A'}', // Displaying completion status
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Course: ${Educations['course'] ?? 'N/A'}', // Displaying course
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'CGPA: ${Educations['cgpa'] ?? 'N/A'}', // Displaying CGPA
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Icon to represent education section
            Container(
              child: Positioned(
                top: 25,
                child: const Icon(
                  Icons.school,
                  color: Colors.grey,
                ),
              ),
            ),
            // Button to edit education details
            Positioned(
              top: 25,
              right: 8,
              child: InkWell(
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/128/1827/1827933.png",
                  color: const Color.fromARGB(255, 85, 143, 151),
                  height: 20,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditEducation(),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
