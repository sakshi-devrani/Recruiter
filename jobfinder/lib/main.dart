// ignore_for_file: avoid_print, unused_local_variable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jobfinder/Jobs/home_posted.dart';
import 'package:jobfinder/firebase_options.dart';
import 'package:jobfinder/language/languageController%5B1%5D.dart';
import 'package:jobfinder/onboarding/onboarding_screen.dart';
import 'package:jobfinder/user/list_job.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyA81P8VDZsrEK7aKXX1eiinvPuH7TPt8dU',
              appId: "1:281362556439:android:d0e4e6969e517a58699e52",
              messagingSenderId: '281362556439',
              projectId: 'jobfinder-3a193'))
      : await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return GetMaterialApp(
      translationsKeys: AppTranslations().keys,
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data != null) {
            // User is logged in
            final user = snapshot.data!;
            // Check user's usertype and navigate accordingly
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Scaffold(
                      body: Center(child: Text('Error fetching data')));
                } else {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  final userType = userData?['usertype'];

                  if (userData == null) {
                    // Handle null data case, navigate to default screen or show error
                    return OnboardingScreen();
                  } else if (userType == 'admin') {
                    return Home_postedjob();
                  } else {
                    return User_job_list();
                  }
                }
              },
            );
                    }
          // User is not logged in or data not loaded yet, show onboarding screen
          return OnboardingScreen();
        },
      ),
    );
  }
}
