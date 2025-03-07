import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:amazetalk_flutter/widgets/loader.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:light_sensor/light_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../blocs/chats_bloc/chats_bloc.dart';

const String URL = BACKEND_URL; // Replace with your server URL

class ChatScreen extends StatefulWidget {
  final String userId;
  final String roomId;
  final String chatName;
  final bool isGroupChat;
  const ChatScreen(
      {super.key,
      required this.userId,
      required this.roomId,
      required this.chatName,
      required this.isGroupChat});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isDarkMode = false;
  IO.Socket? socket;
  List<dynamic> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool otherUserTyping = false;
  bool showEmojiPicker = false;
  bool loading = false;
  bool sendingMsg = false;
  bool showAlert = false;
  Timer? typingTimer; // Timer to manage stop typing event
  bool isTyping = false; // Tracks whether we are currently in "typing" state

// Search members
  bool isSearching = false;
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
        print('Search results: $data');
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
      print('Error: $e');
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
        return isDarkMode
            ? AlertDialog(
                backgroundColor: Colors.grey[900], // Dark background
                title: const Text(
                  'Search Results',
                  style: TextStyle(color: Colors.white), // Light text color
                ),
                content: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.maxFinite,
                        child: _results.isEmpty
                            ? const Text(
                                'No users found.',
                                style: TextStyle(
                                    color: Colors.white70), // Subtle text
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _results.length,
                                itemBuilder: (context, index) {
                                  final user = _results[index];
                                  print('user:  $user');
                                  final userId = user['_id'];
                                  print('dfgdg: ${user["avatar"]}');
                                  return BlocListener<ChatsBloc, ChatsState>(
                                    listener: (context, state) {
                                      if (state is MemberAddedToGroup ||
                                          state is MemberAddedToGroupFailed) {
                                        // pop searched window
                                        Navigator.pop(context);

                                        // Clear search field
                                        _searchController.clear();
                                        setState(() {
                                          isSearching = false;
                                        });

                                        // Show scaffold if add member success / failed
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              state is MemberAddedToGroup
                                                  ? 'Member added to this Group'
                                                  : 'Failed to add member to this Group',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                state is MemberAddedToGroup
                                                    ? Colors.green[800]
                                                    : Colors.red[800],
                                          ),
                                        );
                                      }
                                    },
                                    child: Card(
                                      color: Colors.grey[850], // Dark card
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: ListTile(
                                        onTap: () {
                                          // Add member to this chat
                                          BlocProvider.of<ChatsBloc>(context)
                                              .add(AddMemberToGroup(
                                                  userId, widget.roomId));
                                        },
                                        leading: CircleAvatar(
                                          // backgroundImage: user['avatar'] !=
                                          //         null
                                          //     ? NetworkImage(
                                          //         getAvatarUrl(user['avatar']))
                                          //     : null,
                                          child: user['avatar'] == null ||
                                                  (user['avatar']).isEmpty
                                              ? Text(
                                                  (user['name'][0])
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )
                                              : ClipOval(
                                                  child: Image.network(
                                                    BACKEND_URL +
                                                        user['avatar'],
                                                    fit: BoxFit.cover,
                                                    width:
                                                        72, // Double the radius
                                                    height: 72,
                                                    // loadingBuilder: (context, _, __) =>
                                                    //     const CircularProgressIndicator(
                                                    //   color: Colors.blue,
                                                    // ),
                                                    errorBuilder:
                                                        (context, url, error) =>
                                                            const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        title: Text(
                                          user['name'] ?? '',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          user['email'] ?? '',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style:
                          TextStyle(color: Colors.blueAccent), // Button color
                    ),
                  )
                ],
              )
            : AlertDialog(
                title: const Text('Search Results'),
                content: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.maxFinite,
                        child: _results.isEmpty
                            ? const Text('No users found.')
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _results.length,
                                itemBuilder: (context, index) {
                                  final user = _results[index];
                                  final userId = user['_id'];

                                  print('user: $user');
                                  print('avatar: ${user['avatar']}');
                                  return BlocListener<ChatsBloc, ChatsState>(
                                    listener: (context, state) {
                                      if (state is MemberAddedToGroup ||
                                          state is MemberAddedToGroupFailed) {
                                        // pop searched window
                                        Navigator.pop(context);

                                        // Clear search field
                                        _searchController.clear();
                                        setState(() {
                                          isSearching = false;
                                        });

                                        // Show scaffold if add member success / failed

                                        if (state is MemberAddedToGroup) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Member added to this Group',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  backgroundColor: Colors.red));
                                        } else if (state
                                            is MemberAddedToGroupFailed) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Failed to add member to this Group',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  backgroundColor: Colors.red));
                                        }
                                      }
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: ListTile(
                                        onTap: () {
                                          // Add member to this chat
                                          BlocProvider.of<ChatsBloc>(context)
                                              .add(AddMemberToGroup(
                                                  userId, widget.roomId));
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              user['avatar'].isNotEmpty
                                                  ? NetworkImage(user['avatar'])
                                                  : null,
                                          child: user['avatar'].isEmpty
                                              ? Text((user['name'][0])
                                                  .toUpperCase())
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

  void onShake() {
    print('Shaking...........................');
    sendMessage('👍');
  }

  @override
  void initState() {
    super.initState();
    connectSocket();
    fetchMessages();
    initLightSensor();
    // initTiltSensor();
    ShakeGesture.registerCallback(onShake: onShake);
  }

  final double tiltThreshold = 2.0;

  void initTiltSensor() {
    super.initState();
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        String emojiReaction = '???';

        if (event.y > tiltThreshold) {
          emojiReaction = "😂";
        } else if (event.y < -tiltThreshold) {
          emojiReaction = "❤️";
        }
        print('Emoji: $emojiReaction   value:  ${event.y}');
      });
    });
  }

  void initLightSensor() async {
    if (Platform.isAndroid && await LightSensor.hasSensor()) {
      print('Have light sensor');
      // Subscribe on updates
      LightSensor.luxStream().listen((lux) {
        print('lux value: $lux ...........................');
        setState(() {
          isDarkMode = lux < 5; //9842063607
        });
      });
    } else {
      print('Have no sensor');
    }
  }

  void connectSocket() {
    String userId = widget.userId;
    String chatId = widget.roomId;
    // Create and connect the socket
    socket = IO.io(BACKEND_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket?.connect();

    socket?.on('connect', (_) {
      debugPrint('Connected to socket server');
      // Setup the socket with the user ID
      socket?.emit('setup', userId);
    });

    socket?.on('connected', (_) {
      debugPrint('Socket setup complete');
      // Join a specific chat room
      socket?.emit('join chat', chatId);
    });

    // Listen for new messages
    socket?.on('message received', (data) {
      debugPrint('Message received: $data');
      setState(() {
        messages.add(data);
      });
      scrollDown();
    });

    // Listen for typing events from others
    socket?.on('typing', (room) {
      if (room == chatId) {
        setState(() {
          otherUserTyping = true;
        });
      }
    });

    socket?.on('stop typing', (room) {
      if (room == chatId) {
        setState(() {
          otherUserTyping = false;
        });
      }
    });

    // Optionally handle user online/offline events
    socket?.on('user online', (uid) {
      debugPrint('User online: $uid');
    });

    socket?.on('user offline', (uid) {
      debugPrint('User offline: $uid');
    });

    socket?.on('disconnect', (_) {
      debugPrint('Disconnected from socket server');
    });
  }

  // Fetch messages from an API endpoint (simulate with your own API)
  void fetchMessages() async {
    String chatId = widget.roomId;
    final localAuthToken = await AuthLocalDataSource().getToken();
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$URL/message/$chatId'),
        headers: {
          'Authorization': 'Bearer $localAuthToken',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages = data;
        });
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
    setState(() {
      loading = false;
    });
    scrollDown();
  }

  // Send a message using an API call then emit a socket event
  void sendMessage([String? messageValue]) async {
    final localAuthToken = await AuthLocalDataSource().getToken();
    String chatId = widget.roomId;
    if (_messageController.text.trim().isEmpty && messageValue == null) return;
    // Cancel any pending stop typing event as we are sending the message
    _stopTyping();
    setState(() {
      sendingMsg = true;
      showAlert = false;
    });
    final messageContent = _messageController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('$URL/message/'),
        headers: {
          'Authorization': 'Bearer $localAuthToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'content': messageValue ?? messageContent,
          'chatId': chatId,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Emit the new message via socket
        socket?.emit('new message', data);
        setState(() {
          messages.add(data);
        });
        _messageController.clear();
        scrollDown();
      } else {
        setState(() {
          showAlert = true;
        });
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      setState(() {
        showAlert = true;
      });
    }
    setState(() {
      sendingMsg = false;
    });
  }

  // Called on every text change to manage typing status using a timer.
  void onTyping(String text) {
    String chatId = widget.roomId;
    if (text.isNotEmpty && !isTyping) {
      isTyping = true;
      socket?.emit('typing', chatId);
    }
    // Cancel any existing timer and start a new one.
    typingTimer?.cancel();
    typingTimer = Timer(const Duration(seconds: 2), () {
      _stopTyping();
    });
  }

  void _stopTyping() {
    if (isTyping) {
      isTyping = false;
      socket?.emit('stop typing', widget.roomId);
    }
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Toggle emoji picker visibility and hide the keyboard.
  void toggleEmojiPicker() {
    FocusScope.of(context).unfocus();
    setState(() {
      showEmojiPicker = !showEmojiPicker;
    });
  }

  // Append selected emoji to the text input.
  void addEmoji(String emoji) {
    setState(() {
      _messageController.text += emoji;
    });
  }

  // Show group information in a modal dialog.
  void showGroupInfo() {
    // call bloc to fetch Group Info
    BlocProvider.of<ChatsBloc>(context).add(GroupInfo(widget.roomId));
    showDialog(
      context: context,
      builder: (context) {
        return isDarkMode
            ? AlertDialog(
                backgroundColor: Colors.grey[900], // Dark background
                title: const Text(
                  'Group Info',
                  style: TextStyle(color: Colors.white), // Light text
                ),
                content: BlocBuilder<ChatsBloc, ChatsState>(
                  builder: (context, state) {
                    if (state is GroupInfoFetched) {
                      final info = state.info;
                      return SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: info.userMappings.length,
                          itemBuilder: (context, index) {
                            final user = info.userMappings[index];
                            final userImage = user.userImage;
                            final username = user.username;
                            return Card(
                              color: Colors.grey[850], // Dark card
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: userImage != null
                                      ? NetworkImage(userImage)
                                      : null,
                                  child: userImage == null
                                      ? Text(
                                          username[0].toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  user.getDisplayName(state.uid),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: user.isAdmin
                                    ? const Text(
                                        'Admin',
                                        style: TextStyle(
                                            color: Colors.orangeAccent),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style:
                          TextStyle(color: Colors.blueAccent), // Button color
                    ),
                  )
                ],
              )
            : AlertDialog(
                title: const Text('Group Info'),
                content: BlocBuilder<ChatsBloc, ChatsState>(
                  builder: (context, state) {
                    if (state is GroupInfoFetched) {
                      final info = state.info;
                      return SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: info.userMappings.length,
                          itemBuilder: (context, index) {
                            final user = info.userMappings[index];
                            final userImage = user.userImage;
                            final username = user.username;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: userImage != null
                                    ? NetworkImage(userImage)
                                    : null,
                                child: userImage == null
                                    ? Text(username[0].toUpperCase())
                                    : null,
                              ),
                              title: Text(user.getDisplayName(state.uid)),
                              subtitle:
                                  user.isAdmin ? const Text('Admin') : null,
                            );
                          },
                        ),
                      );
                    }

                    return Loader();
                  },
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
  void dispose() {
    typingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    socket?.disconnect();
    _searchController.dispose();
    ShakeGesture.unregisterCallback(onShake: onShake);

    LightSensor.luxStream().drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : Colors.white, // Dynamic background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode
                  ? Colors.white
                  : Colors.black), // Change icon color
          onPressed: () {
            BlocProvider.of<ChatsBloc>(context).add(FetchChats());
            Navigator.of(context).pop();
          },
        ),
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Users...',
                  hintStyle: TextStyle(
                      color: isDarkMode
                          ? Colors.grey
                          : Colors.black54), // Dark mode hint text
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black), // Dark mode input text
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  final query = value.trim();
                  if (query.isNotEmpty) {
                    _fetchUsers(query).then((_) => _showResultsPopup());
                  }
                },
              )
            : Text(
                widget.chatName,
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
        actions: widget.isGroupChat
            ? [
                isSearching
                    ? IconButton(
                        icon: Icon(Icons.clear,
                            color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            isSearching = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.person_add_rounded,
                            color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                      ),

                // Show group info button
                IconButton(
                  icon: Icon(Icons.info_outline,
                      color: isDarkMode ? Colors.white : Colors.black),
                  onPressed: showGroupInfo,
                ),
              ]
            : [
                IconButton(
                    onPressed: () {
                      isDarkMode = !isDarkMode;
                      setState(() {});
                    },
                    icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode))
              ],
        backgroundColor:
            isDarkMode ? Colors.grey[900] : Colors.white, // Dynamic app bar
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: Container(
              color: isDarkMode
                  ? Colors.black
                  : Colors.grey[200], // Dark mode background
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSelf = message['sender']['_id'] == userId;
                        return Align(
                          alignment: isSelf
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelf
                                  ? Colors.blue[700]
                                  : isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white, // Dynamic message bubbles
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message['content'] ?? '',
                              style: TextStyle(
                                color: isSelf
                                    ? Colors.white
                                    : isDarkMode
                                        ? Colors.white70
                                        : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Typing indicator from others
          if (otherUserTyping)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Someone is typing...',
                style:
                    TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
              ),
            ),
          // Show an error alert if needed
          if (showAlert)
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Error sending message. Check your network connection.',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          // Input area: emoji toggle, text input, and send button
          Container(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    showEmojiPicker
                        ? Icons.clear
                        : Icons.emoji_emotions_outlined,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: toggleEmojiPicker,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) {
                      onTyping(text);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.black54),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white, // Dynamic input field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                    onSubmitted: (text) {
                      sendMessage();
                      _stopTyping();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,
                      color: isDarkMode ? Colors.blueAccent : Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
          // Emoji picker
          if (showEmojiPicker)
            SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    addEmoji(emoji.emoji);
                  },
                  textEditingController: _messageController,
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.20
                              : 1.0),
                    ),
                    viewOrderConfig: const ViewOrderConfig(
                      top: EmojiPickerItem.categoryBar,
                      middle: EmojiPickerItem.emojiView,
                      bottom: EmojiPickerItem.searchBar,
                    ),
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: const CategoryViewConfig(),
                    bottomActionBarConfig: const BottomActionBarConfig(),
                    searchViewConfig: const SearchViewConfig(),
                  ),
                )),
        ],
      ),
    );
  }
}
