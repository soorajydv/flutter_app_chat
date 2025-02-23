import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/messages_bloc/messages_bloc.dart';

class MessagePage extends StatelessWidget {
  const MessagePage(this.chatId, {super.key, required this.chatName});
  final String chatId;
  final String chatName;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessagesBloc>(context).add(FetchMessages(chatId));
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Text('Avatar'),
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://d3lzcn6mbbadaf.cloudfront.net/media/details/ANI-20240220151042.jpg'),
            ),
            SizedBox(width: 10),
            Text(chatName[0].toUpperCase() + chatName.substring(1)),
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
        child:
            BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
          if (state is MessagesLoaded) {
            print('\n\nMessages fetched\n\n');
            final messages = state.messages;
            final uid = state.uid;
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          if (message.sender.id == uid) {
                            return _buildSentMessage(context, message.content);
                          } else {
                            return _buildReceivedMessage(
                                context, message.content);
                          }
                        })),
                _buildMessageInput(),
              ],
            );
          }

          if (state is MessagesError) {
            return Center(
                child:
                    Text(state.message, style: TextStyle(color: Colors.red)));
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        }),
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
