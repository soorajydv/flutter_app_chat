//  {
//       "_id": "67acdc9f929d36e4a3528742",
//       "conversation": "67acdc9f929d36e4a3528740",
//       "sender": {
//           "_id": "67ab40490cdc6dcf6bd68000",
//           "username": "ksandresh1"
//       },
//       "text": "Hi",
//       "createdAt": "2025-02-12T17:38:39.312Z",
//       "updatedAt": "2025-02-12T17:38:39.312Z",
//       "__v": 0
//   },
class ConversationEntity {
  final String id;
  final String conversation;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConversationEntity(
      {required this.id,
      required this.conversation,
      required this.senderId,
      required this.senderName,
      required this.message,
      required this.createdAt,
      required this.updatedAt});
}
