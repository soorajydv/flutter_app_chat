// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'features/conversation/presentation/blocs/messages_bloc/messages_bloc.dart';

// class ChatPage extends StatelessWidget {
//   const ChatPage(this.conversationId, {super.key});
//   final String conversationId;

//   @override
//   Widget build(BuildContext context) {
//     BlocProvider.of<MessagesBloc>(context).add(FetchMessages(conversationId));
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
//           if (state is MessagesLoaded) {
//             return Row(
//               children: [
//                 Text('Avatar'),
//                 // CircleAvatar(
//                 //   backgroundImage: NetworkImage(
//                 //       'https://www.m9.news/wp-content/uploads/2025/01/shah-rukh-khan-768x576.jpg'),
//                 // ),
//                 SizedBox(width: 10),
//                 Text(state.conversation.friendName),
//               ],
//             );
//           }
//           return SizedBox.shrink();
//         }),
//         elevation: 0,
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.search),
//           ),
//         ],
//       ),
//       body: Center(
//         child:
//             BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
//           if (state is MessagesLoaded) {
//             final messages = state.conversation.messages;
//             return Column(
//               children: [
//                 Expanded(
//                     child: ListView.builder(
//                         padding: EdgeInsets.all(20),
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           final message = messages[index];
//                           if (message.isReceived) {
//                             return _buildReceivedMessage(
//                                 context, message.message);
//                           }
//                           if (message.isSent) {
//                             return _buildSentMessage(context, message.message);
//                           }
//                         })),
//                 _buildMessageInput(),
//               ],
//             );
//           }

//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildReceivedMessage(BuildContext context, String message) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(message),
//       ),
//     );
//   }

//   Widget _buildSentMessage(BuildContext context, String message) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.blueGrey[200],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(message),
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 227, 215, 215),
//           borderRadius: BorderRadius.circular(25)),
//       margin: EdgeInsets.all(25),
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: Row(
//         children: [
//           GestureDetector(
//             child: Icon(
//               Icons.camera_alt,
//               color: Colors.grey,
//             ),
//             onTap: () {},
//           ),
//           SizedBox(width: 10),
//           Expanded(
//               child: TextField(
//             decoration: InputDecoration(
//               hintText: "Type Your Message",
//               border: InputBorder.none, // Removes the underline
//               enabledBorder:
//                   InputBorder.none, // Ensures no border when not focused
//               focusedBorder: InputBorder.none, // Ensures no border when focused
//             ),
//           )),
//           SizedBox(
//             width: 10,
//           ),
//           GestureDetector(
//             child: Icon(
//               Icons.send,
//               color: Colors.grey,
//             ),
//             onTap: () {},
//           )
//         ],
//       ),
//     );
//   }
// }
