// ignore_for_file: unnecessary_import, prefer_const_constructors, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hexcolor/hexcolor.dart';

// Class to represent a message with sender information
class Message {
  final String sender;
  final String content;

  Message({
    required this.sender,
    required this.content,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  late final GenerativeModel _model;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey:
          'AIzaSyC8LwXmoqxgLBSSeI6KaOpaTBI7k8paYsQ', // Replace with your actual API key
    );
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.isNotEmpty;
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(sender: 'Arjun', content: _controller.text));
        _controller.clear();
        _isTyping = false;
      });
    }
  }

  Future<void> _sendPrompt() async {
    final userMessage = _controller.text.trim();
    _controller.clear();

    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add(Message(sender: 'Arjun', content: userMessage));
    });

    try {
      final prompt = [Content.text(userMessage)];
      final response = await _model.generateContent(prompt);

      setState(() {
        _messages.add(Message(
            sender: 'ChatGPT', content: response.text ?? 'No response'));
      });
    } catch (e) {
      setState(() {
        _messages.add(
            Message(sender: 'ChatGPT', content: 'Error - ${e.toString()}'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor('ffffff'),
        title: Row(
          children: [
            SizedBox(width: width / 300),
            Icon(FontAwesomeIcons.bars),
            SizedBox(width: width / 4.5),
            Container(
              height: height / 25,
              width: width / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor('f4f4f4'),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Plus',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: height / 60,
                    ),
                  ),
                  Text(
                    '   +',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: height / 40,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: width / 8),
            Icon(FontAwesomeIcons.edit),
            SizedBox(width: width / 20),
            Icon(Icons.more_vert_outlined),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_messages[index].sender == 'Arjun')
                            CircleAvatar(
                              radius: height / 70,
                              backgroundColor: Colors.black,
                            )
                          else
                            CircleAvatar(
                              radius: height / 70,
                              backgroundImage: AssetImage('images/gpt1.jpg'),
                              // Replace with your ChatGPT avatar image path
                            ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: HexColor('f4f4f4'),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _messages[index].sender,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    _messages[index].content,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_messages.isEmpty)
                Image.asset(
                  'images/gpt1.jpg', // Adjust width to fit within the available space
                  cacheHeight: 50,
                  height: height / 3,
                ),
              if (_messages.isEmpty)
                Column(
                  children: [
                    SizedBox(height: height / 70),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: width / 20),
                            Container(
                              height: height / 12,
                              width: width / 1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('f4f4f4'),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height / 70),
                                  Text(
                                    '  Write a text',
                                    style: TextStyle(
                                      fontSize: height / 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '   inviting my neighbors to a barbecue',
                                    style: TextStyle(
                                      fontSize: height / 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: width / 20),
                            Container(
                              height: height / 12,
                              width: width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('f4f4f4'),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height / 70),
                                  Text(
                                    '  Explain nostalgia',
                                    style: TextStyle(
                                      fontSize: height / 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '  to a kindergartener',
                                    style: TextStyle(
                                      fontSize: height / 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: width / 20),
                            Container(
                              height: height / 12,
                              width: width / 1.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('f4f4f4'),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height / 70),
                                  Text(
                                    '  Make me a personal webpage',
                                    style: TextStyle(
                                      fontSize: height / 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '  after asking me three questions',
                                    style: TextStyle(
                                      fontSize: height / 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: width / 20),
                            Container(
                              height: height / 12,
                              width: width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('f4f4f4'),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: height / 70),
                                  Text(
                                    '  Tell me a fun fact',
                                    style: TextStyle(
                                      fontSize: height / 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '  about the Roman Empire',
                                    style: TextStyle(
                                      fontSize: height / 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: width / 20),
                          ],
                        ))
                  ],
                ),
              SizedBox(height: height / 70),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: height / 18,
                      width: width / 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: HexColor('e8e8e8'),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, size: height / 30),
                        onPressed: _sendMessage,
                      ),
                    ),
                    SizedBox(width: width / 25),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type your message',
                              fillColor: HexColor('e8e8e8'),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: HexColor('f4f4f4'),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: HexColor('f4f4f4'),
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: height / 70,
                                horizontal: 20,
                              ),
                            ),
                          ),
                          if (!_isTyping)
                            Positioned(
                              right: 20,
                              child: Icon(
                                Icons.mic,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: _isTyping
                          ? Container(
                              height: height / 18,
                              width: width / 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.black,
                              ),
                              child: Icon(
                                Icons.arrow_upward_outlined,
                                size: height / 40,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.headphones, color: Colors.black),
                      onPressed: _isTyping ? _sendPrompt : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
