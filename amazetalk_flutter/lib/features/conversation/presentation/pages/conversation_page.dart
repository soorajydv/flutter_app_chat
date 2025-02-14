import 'package:amazetalk_flutter/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/bloc/conversation_event.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
  }

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
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationsLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ConversationsLoaded) {
                      return ListView.builder(
                        itemCount: state.conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = state.conversations[index];
                          return _buildMessageTile(
                              conversation.senderName,
                              conversation.message,
                              conversation.createdAt.toString());
                        },
                      );
                    } else if (state is ConversationsError) {
                      return Center(
                        child: Text(state.message),
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
