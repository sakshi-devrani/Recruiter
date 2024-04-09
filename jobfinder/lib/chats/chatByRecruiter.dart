import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatRecruiter extends StatefulWidget {
  final String jobId;
  final String applicationId;
  final String email;
  ChatRecruiter(
      {required this.jobId, required this.applicationId, required this.email});
  @override
  _ChatRecruiterState createState() => _ChatRecruiterState();
}
class _ChatRecruiterState extends State<ChatRecruiter> {
  TextEditingController messageController = TextEditingController();
  late CollectionReference messagesCollection;
  File? _image;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Request permission and set notification options for Firebase messaging
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.requestPermission();
    // Setup Firebase messaging listeners
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages when the app is in the foreground
      print("onMessage: $message");
      // Show notification or handle message as required
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification taps when the app is in the background
      print("onMessageOpenedApp: $message");
      // Navigate to chat screen or handle message as required
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      // Handle background messages
      print("Handling a background message: ${message.messageId}");
      // Handle notification or perform background tasks
    });
    // Get reference to the messages collection in Firestore
    messagesCollection = FirebaseFirestore.instance
        .collection('jobsposted')
        .doc(widget.jobId)
        .collection('applications')
        .doc(widget.applicationId)
        .collection('messages');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
        titleSpacing: 1,
        title: Row(
          children: [
            // Display user's profile picture
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
            // Display user's email in app bar title
            Text(
              widget.email.toString(),
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ],
        ),
        // Add back button to navigate back to previous screen
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
              // Stream for real-time updates of messages
              stream: messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                // Extract messages data from snapshot
                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

                // Scroll to the bottom of the messages list whenever new messages are received
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    // Extract message data for each message
                    Map<String, dynamic> messageData =
                        messages[index].data() as Map<String, dynamic>;

                    String messageText = messageData['message'];
                    String sender = messageData['sender'];
                    Timestamp? timestamp = messageData['timestamp'];

                    // Format timestamp to display in user-friendly format
                    String formattedTime = 'Timestamp not available';

                    if (timestamp != null) {
                      DateTime dateTime = timestamp.toDate();
                      formattedTime =
                          DateFormat('HH:mm:ss dd-MM-yy').format(dateTime);
                    }

                    // Determine if the user is the sender of the message
                    bool isUserSender = sender == 'Recruiter';
                    if (isUserSender) {
                      sender = 'you ';
                    }

                    // Display the message in a ListTile
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
                          if (!isUserSender) const SizedBox(width: 8),
                          Text(
                            sender,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isUserSender) const SizedBox(width: 8),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                                fontSize: 8,
                                color: Color.fromARGB(255, 85, 143, 151)),
                          ),
                        ],
                      ),
                      contentPadding: isUserSender
                          ? const EdgeInsets.only(left: 80.0, right: 8.0)
                          : const EdgeInsets.only(left: 8.0, right: 80.0),
                    );
                  },
                );
              },
            ),
          ),
          // Input field for sending messages
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: messageController,
                  cursorColor: Color.fromARGB(255, 85, 143, 151),
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 85, 143, 151)),
                    hintText: 'Type your message here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 85, 143, 151),
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 85, 143, 151)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 227, 231, 231),
                  ),
                )),
                // Button to send message
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 85, 143, 151),
                  ),
                  onPressed: () {
                    // Send message when send button is pressed
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
      'sender': 'Recruiter',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
