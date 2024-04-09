import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        title: Text('Help & Support'),
        // Customize app bar as needed
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildFAQ('How do I create an account?',
                'To create an account, click on the "Sign Up" button and follow the instructions.'),
            _buildFAQ('How do I apply for a job?',
                'To apply for a job, go to the job listing and click on the "Apply" button.'),
            _buildFAQ('I forgot my password. What should I do?',
                'You can reset your password by clicking on the "Forgot Password" link on the login screen.'),
            SizedBox(height: 40),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildContactInfo('Email', 'support@jobfinder.com'),
            _buildContactInfo('Phone', '+1 (123) 456-7890'),
            SizedBox(height: 40),
            Text(
              'Feedback',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildFeedbackForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(answer),
        ),
      ],
    );
  }

  Widget _buildContactInfo(String label, String info) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(info),
      leading: Icon(Icons.contact_support),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Your Feedback',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          // Implement logic to handle feedback submission
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 85, 143, 151),
            ),
          ),
          onPressed: () {
            // Implement logic to handle feedback submission
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
