import 'package:amazetalk_flutter/chat_page.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/chats_bloc/chats_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/humanize.dart';
import 'chat_page2.dart';
// import 'chat_page.dart';
// import 'mesage_page.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatsBloc>(context).add(FetchChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Conversations'),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 70,
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.search),
          //   )
          // ],
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
                child: BlocBuilder<ChatsBloc, ChatsState>(
                  builder: (context, state) {
                    if (state is ChatsLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ChatsFetched) {
                      final chats = state.chats;
                      return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          // print(
                          //     'Conversation: ${conversation.sender!.name} =>  ${conversation.text}');
                          return _buildMessageTile(
                              chat.chatName,
                              chat.latestMessage.content,
                              chat.latestMessage.createdAt.toString(),
                              chat.id,
                              chat.isGroupChat,
                              chat.chatName,
                              state.uid);
                        },
                      );
                    } else if (state is ChatsFailure) {
                      return Center(
                        child: Text('Error Occured: ${state.message}'),
                      );
                    }
                    return Center(child: Text("No conversation found"));
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildMessageTile(String name, String message, String time,
      String conversationId, bool isGroup, String chatName, String uid) {
    return ListTile(
      onTap: () {
        // Navigator.pushNamed(context, "/chatPage");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              roomId: conversationId,
              userId: uid,
              chatName: chatName,
              // conversationId,
              // chatName: chatName,
            ),
          ),
        );
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      leading: CircleAvatar(
        radius: 30,
        child: Text(isGroup ? "G" : name[0].toUpperCase(),
            style: TextStyle(fontSize: 30)),
      ),
      // CircleAvatar(
      //   radius: 30,
      //   backgroundImage: NetworkImage(""),
      // ),
      title: Text(name),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        humanizeDateTime(DateTime.parse(time)),
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
