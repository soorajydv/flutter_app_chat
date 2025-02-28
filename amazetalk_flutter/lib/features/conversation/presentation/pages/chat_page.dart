import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userId, required this.roomId});

  final String userId;
  final String roomId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  IO.Socket? socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  // For demo purposes, use fixed user and room IDs.
  // String userId = widget.userId;
  // String roomId = widget.roomId;

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    String userId = widget.userId;
    String roomId = widget.roomId;
    // Replace with your Socket.IO server URL
    socket = IO.io(BACKEND_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      print('Connected to socket server');
      // Send setup event with userId
      socket!.emit('setup', userId);
    });

    socket!.on('connected', (_) {
      print('Socket setup complete, joining room');
      // Join chat room
      socket!.emit('join chat', roomId);
    });

    // Listen for incoming messages from other users
    socket!.on('message received', (data) {
      print('Message received: $data');
      setState(() {
        messages.add(Map<String, dynamic>.from(data));
      });
    });

    // Listen for typing events
    socket!.on('typing', (room) {
      print('Someone is typing in room: $room');
      setState(() {
        isTyping = true;
      });
    });

    socket!.on('stop typing', (room) {
      print('Stop typing in room: $room');
      setState(() {
        isTyping = false;
      });
    });

    // Optionally listen for user online/offline events
    socket!.on('user online', (userId) {
      print('User online: $userId');
    });

    socket!.on('user offline', (userId) {
      print('User offline: $userId');
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from socket server');
    });
  }

  void sendMessage(String messageText) {
    String userId = widget.userId;
    String roomId = widget.roomId;
    if (messageText.trim().isEmpty) return;

    // Construct message data (simplified for demo purposes)
    final messageData = {
      "sender": {
        "_id": userId,
        "name": "Demo User",
        "email": "demo@example.com",
        "image": null,
      },
      "content": messageText,
      "chat": {
        "_id": roomId,
        "chatName": "Demo Chat",
        "isGroupChat": false,
        "users": [userId, "user2"], // dummy list of users
        "latestMessage": "",
      }
    };

    // Emit new message event
    socket!.emit('new message', messageData);

    // Optionally, add the message locally immediately
    setState(() {
      messages.add(messageData);
    });

    _controller.clear();
  }

  void startTyping() {
    socket!.emit('typing', widget.roomId);
  }

  void stopTyping() {
    socket!.emit('stop typing', widget.roomId);
  }

  @override
  void dispose() {
    _controller.dispose();
    socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg['sender']['name'] ?? 'Unknown'),
                  subtitle: Text(msg['content'] ?? ''),
                );
              },
            ),
          ),
          if (isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text("Someone is typing..."),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        startTyping();
                      } else {
                        stopTyping();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    stopTyping();
                    sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
