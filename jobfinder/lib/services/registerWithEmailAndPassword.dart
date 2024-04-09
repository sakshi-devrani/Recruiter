import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jobfinder/Profile%20Components/Logine.dart';

Future<void> registerWithEmailAndPassword(
    String email, String phoneNumber) async {
  try {
    User? userid = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(userid!.uid)
        .set({
      'uid': userid.uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'usertype': "",
    });
    await FirebaseFirestore.instance.collection('users').doc(userid.uid).set({
      'uid': userid.uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'usertype': "",
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Get.to(() => LoginPage()),
        });
  } catch (e) {}
}
