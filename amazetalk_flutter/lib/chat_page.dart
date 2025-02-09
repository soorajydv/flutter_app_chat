import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(""),
            ),
            SizedBox(width: 10),
            Text("Sandesh"),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _buildReceivedMessage(context, "Test test"),
                _buildSentMessage(context, "Hello hello"),
              ],
            )),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blueGrey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 227, 215, 215),
          borderRadius: BorderRadius.circular(25)),
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.camera_alt,
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          SizedBox(width: 10),
          Expanded(
              child: TextField(
            decoration: InputDecoration(
              hintText: "Type Your Message",
              border: InputBorder.none, // Removes the underline
              enabledBorder:
                  InputBorder.none, // Ensures no border when not focused
              focusedBorder: InputBorder.none, // Ensures no border when focused
            ),
          )),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            child: Icon(
              Icons.send,
              color: Colors.grey,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
