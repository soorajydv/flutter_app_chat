import 'dart:convert';

import 'package:amazetalk_flutter/chat_page.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/chats_bloc/chats_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/urls.dart';
import '../../../../utils/humanize.dart';
import '../../../auth/data/datasource/auth_local_data_source.dart';
import 'chat_page2.dart';
import 'package:http/http.dart' as http;
// import 'chat_page.dart';
// import 'mesage_page.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  bool isSearching = true;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _results = [];
  bool _loading = false;
  bool _error = false;

  /// Calls the /fetchUsers API using the provided search query.
  Future<void> _fetchUsers(String query) async {
    setState(() {
      _loading = true;
      _error = false;
    });
    final token = await AuthLocalDataSource().getToken();
    try {
      // Adjust the endpoint and query parameter as needed.
      final response = await http.get(
        Uri.parse('$BACKEND_URL/user/fetchUsers?search=$query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Search results: ${data}');
        setState(() {
          _results = data;
        });
      } else {
        print('Error code: ${response.statusCode}');
        setState(() {
          _error = true;
        });
      }
    } catch (e) {
      print('Error: ${e}');
      setState(() {
        _error = true;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  /// Displays the search results in a popup dialog.
  void _showResultsPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Results'),
          content: _loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  width: double.maxFinite,
                  child: _results.isEmpty
                      ? const Text('No users found.')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final user = _results[index];
                            final userId = user['_id'];
                            return BlocListener<ChatsBloc, ChatsState>(
                              listener: (context, state) {
                                if (state is AccessChatFetched) {
                                  // pop searched window
                                  Navigator.pop(context);

                                  //Fetch conversations
                                  BlocProvider.of<ChatsBloc>(context)
                                      .add(FetchChats());

                                  // Clear search field
                                  _searchController.clear();
                                  setState(() {
                                    isSearching = false;
                                  });

                                  // Go to chat page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        roomId: state.chat.id,
                                        userId: userId,
                                        chatName: state.chat.chatName,
                                        // conversationId,
                                        // chatName: chatName,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  onTap: () {
                                    BlocProvider.of<ChatsBloc>(context)
                                        .add(AccessChat(userId));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: user['image'] != null
                                        ? NetworkImage(
                                            'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202410/srk-discusses-adventure-film-with-amar-kaushik-after-king-and-pathaan-2-report-034431846-3x4.jpg?VersionId=4ftMrJ_hzQEQF1NRKWt4JQ8yo2YJBSWX')
                                        : null,
                                    child: user['image'] == null
                                        ? Text((user['name'][0]).toUpperCase())
                                        : null,
                                  ),
                                  title: Text(user['name'] ?? ''),
                                  subtitle: Text(user['email'] ?? ''),
                                ),
                              ),
                            );
                          },
                        ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatsBloc>(context).add(FetchChats());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search Users...',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    final query = value.trim();
                    if (query.isNotEmpty) {
                      _fetchUsers(query).then((_) => _showResultsPopup());
                    }
                  },
                )
              : const Text('Conversations'),
          actions: [
            isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        isSearching = false;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
          ],
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
                              chat.isGroupChat
                                  ? chat.chatName
                                  : (chat.users.first.id != state.uid
                                          ? chat.users.first
                                          : chat.users[1])
                                      .name,
                              chat.latestMessage.content,
                              chat.latestMessage.createdAt.toString(),
                              chat.id,
                              chat.isGroupChat,
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
      String conversationId, bool isGroup, String uid) {
    return ListTile(
      onTap: () {
        // Navigator.pushNamed(context, "/chatPage");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              roomId: conversationId,
              userId: uid,
              chatName: name,
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
            // backgroundImage: NetworkImage(""),
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
