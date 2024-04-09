
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/language/languageDialogBox%5B1%5D.dart';
import 'package:jobfinder/welcome.dart';

class Setting_page extends StatefulWidget {
  const Setting_page({super.key});

  @override
  State<Setting_page> createState() => _Setting_pageState();
}

class _Setting_pageState extends State<Setting_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text('settings'.tr),
      ),
      body: Column(children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text("language".tr),
          onTap: () {
            // Show language selection dialog
            Get.dialog(LanguageDialog());
          },
        ),
        Divider(thickness: 2),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text("logout".tr),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 213, 230, 230),
                        title: Text('logout'.tr),
                        content: Text('l1'.tr),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 85, 143, 151)),
                            ),
                          ),
                          TextButton(
                            onPressed: _signOut,
                            child: Text(
                              'logout'.tr,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 85, 143, 151)),
                            ),
                          ),
                        ]);
                  });
            }),
        Divider(thickness: 2),
      ]),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Welcome();
        },
      ));
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
