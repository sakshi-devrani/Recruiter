import 'dart:io';
import 'package:flutter/material.dart';

class CertificateItem extends StatelessWidget {
  final String certificateName;
  final String organization;
  final String issuedYear;
  final File? file;

  const CertificateItem({
    required this.certificateName,
    required this.organization,
    required this.issuedYear,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
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
                      // Displaying certificate name
                      Text(
                        'Certificate Name: $certificateName',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 8),
                      // Displaying organization
                      Text(
                        'Organization: $organization',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      // Displaying issued year
                      Text(
                        'Issued Year: $issuedYear',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Displaying certificate image if available
          if (file != null)
            Positioned(
              top: 16,
              right: 16,
              child: Image.file(
                file!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
