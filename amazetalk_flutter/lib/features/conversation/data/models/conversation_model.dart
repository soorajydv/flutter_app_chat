import 'package:amazetalk_flutter/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.id,
    required super.conversation,
    required super.senderId,
    required super.senderName,
    required super.message,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] as String,
      conversation: json['conversation'] as String,
      senderId: json['sender']['_id'] as String,
      senderName: json['sender']['username'] as String,
      message: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
