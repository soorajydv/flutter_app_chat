import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 70,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("Recent"),
            ),
            Container(
              height: 100,
              padding: EdgeInsets.all(5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildeRecentContact("Sandesh", context),
                  _buildeRecentContact("Avishek", context),
                  _buildeRecentContact("Samip", context),
                  _buildeRecentContact("Robin", context)
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    _buildMessageTile("Sandesh", "K xa dost", "08:43"),
                    _buildMessageTile("Avishek", "K xa dost", "08:43"),
                    _buildMessageTile("Samip", "K xa dost", "08:43"),
                    _buildMessageTile("Robin", "K xa dost", "08:43"),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildMessageTile(String name, String message, String time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(""),
      ),
      title: Text(name),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildeRecentContact(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(""),
          ),
          SizedBox(
            height: 3,
          ),
          Text(name)
        ],
      ),
    );
  }
}
