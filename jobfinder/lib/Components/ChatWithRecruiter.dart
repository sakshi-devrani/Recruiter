import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ChatPage StatefulWidget represents the chat page
class ChatPage extends StatefulWidget {
  final String jobId;
  final String applicationId;
  final String email;

  ChatPage({
    required this.jobId,
    required this.applicationId,
    required this.email,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  late CollectionReference messagesCollection;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initializing messages collection reference
    messagesCollection = FirebaseFirestore.instance
        .collection('jobsposted')
        .doc(widget.jobId)
        .collection('applications')
        .doc(widget.applicationId)
        .collection('messages');
  }

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        titleSpacing: 1,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: _image != null
                  ? CircleAvatar(
                      radius: 16, backgroundImage: FileImage(_image!))
                  : const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.email.toString(),
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ],
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                // Extracting messages from the snapshot
                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

                // Scrolling to the bottom of the list whenever new messages are added
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> messageData =
                        messages[index].data() as Map<String, dynamic>;
                    String messageText = messageData['message'];
                    String sender = messageData['sender'];
                    Timestamp? timestamp = messageData['timestamp'];

                    String formattedTime = 'Timestamp not available';

                    // Formatting timestamp into readable format
                    if (timestamp != null) {
                      DateTime dateTime = timestamp.toDate();
                      formattedTime =
                          DateFormat('HH:mm:ss dd-MM-yy').format(dateTime);
                    }

                    bool isUserSender = sender == 'Applicant';
                    if (isUserSender) {
                      sender = 'you ';
                    }
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: isUserSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            messageText,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isUserSender
                                    ? Color.fromARGB(255, 85, 143, 151)
                                    : Color.fromARGB(255, 129, 133, 134)),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: isUserSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isUserSender) SizedBox(width: 8),
                          Text(
                            sender,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isUserSender) SizedBox(width: 8),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 8,
                              color: Color.fromARGB(255, 85, 143, 151),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: isUserSender
                          ? EdgeInsets.only(left: 80.0, right: 8.0)
                          : EdgeInsets.only(left: 8.0, right: 80.0),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: messageController,
                  cursorColor: Color.fromARGB(255, 85, 143, 151),
                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 85, 143, 151),
                    ),
                    hintText: 'Type your message here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 85, 143, 151),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 85, 143, 151),
                      ),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 227, 231, 231),
                  ),
                )),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 85, 143, 151),
                  ),
                  onPressed: () {
                    sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Function to send a message
  void sendMessage(String messageText) {
    messagesCollection.add({
      'message': messageText,
      'sender': 'Applicant', // Assuming the sender is the applicant
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      sendPushNotification(messageText); // Sending push notification
    }).catchError((error) {
      print("Failed to send message: $error");
    });
  }

  // Function to send push notification
  void sendPushNotification(String messageText) {
    FirebaseMessaging.instance.getToken().then((token) {
      // Send a push notification to the other party (e.g., employer)
      // You need to determine the recipient's FCM token based on your application's logic
      String recipientToken = "RECIPIENT_FCM_TOKEN_HERE";

      if (recipientToken.isNotEmpty) {
      }
    });
  }
}
