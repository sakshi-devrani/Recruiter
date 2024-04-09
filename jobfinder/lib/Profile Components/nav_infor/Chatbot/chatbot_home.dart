import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jobfinder/Profile%20Components/nav_infor/Chatbot/response_model.dart';

class ChatBotHome extends StatefulWidget {
  const ChatBotHome({Key? key}) : super(key: key);

  @override
  _ChatBotHomeState createState() => _ChatBotHomeState();
}

class _ChatBotHomeState extends State<ChatBotHome> {
  late final TextEditingController promptController;
  String responseTxt = '';

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CHATBOT",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 85, 143, 151),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PromptBuilder(responseTxt: responseTxt),
          TextFormFieldBuilder(
            promptController: promptController,
            btnFun: completionFun,
          ),
        ],
      ),
    );
  }

  Future<void> completionFun() async {
    setState(() => responseTxt = "Loading ....");
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${dotenv.env['token']}'
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": promptController.text}
          ],
          "max_tokens": 60
        }),
      );
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        final responseModel = ResponseModel.fromJson(jsonResponse);
        responseTxt = responseModel.choices[0].message.content;
      });
    } catch (e) {
      setState(() {
        responseTxt = "Error: $e";
      });
    }
  }
}

class PromptBuilder extends StatelessWidget {
  const PromptBuilder({required this.responseTxt});

  final String responseTxt;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Text(
            responseTxt,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class TextFormFieldBuilder extends StatelessWidget {
  const TextFormFieldBuilder({
    required this.promptController,
    required this.btnFun,
  });

  final TextEditingController promptController;
  final Function btnFun;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: Colors.white,
              controller: promptController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff444653),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff444653),
                  ),
                ),
                filled: true,
                fillColor: Color(0xff444653),
                hintText: "Ask Anything !! ",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () => btnFun(),
            icon: const Icon(
              Icons.send,
              size: 40,
              color: Color.fromARGB(255, 85, 143, 151),
            ),
          ),
        ],
      ),
    );
  }
}
