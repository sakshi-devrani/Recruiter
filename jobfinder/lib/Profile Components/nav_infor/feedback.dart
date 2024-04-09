import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:jobfinder/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: FeedbackPage(),
  ));
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFeedback(double rating) async {
    try {
      final feedbackRef = _firestore.collection('feedback');
      await feedbackRef.add({
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Feedback saved successfully!');
    } catch (e) {
      print('Error saving feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text('feedback'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 85, 143, 151),
              )),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 188, 214, 218),
                      title: Text('Feedback Submitted'),
                      content: Text('Thank you for your feedback!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            saveFeedback(_rating);

                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Color.fromARGB(255, 85, 143, 151),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Submit Feedback'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
