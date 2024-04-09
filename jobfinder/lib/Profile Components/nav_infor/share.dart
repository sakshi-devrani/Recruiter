// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text('share page'.tr),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Share via Email'),
            onTap: () {
              _shareViaEmail(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Share via Message'),
            onTap: () {
              _shareViaMessage(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            // Assuming you have a WhatsApp logo asset
            title: Text('Share via WhatsApp'),
            onTap: () {
              _shareViaWhatsApp(context);
            },
          ),
        ],
      ),
    );
  }

  void _shareViaEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'your.email@gmail.com', // Replace with your Gmail address
      queryParameters: {
        'subject': 'Check out this job finder app!',
        'body':
            'I found this amazing job finder app. You should check it out! https://example.com',
      },
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to open email client.'),
        ),
      );
    }
  }

  void _shareViaMessage(BuildContext context) {
    final String text = 'Check out this job finder app: https://example.com';

    Share.share(text);
  }

  void _shareViaWhatsApp(BuildContext context) async {
    final String text = 'Check out this job finder app: https://example.com';

    String url = 'whatsapp://send?text=${Uri.encodeComponent(text)}';

    // Launch the WhatsApp URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
