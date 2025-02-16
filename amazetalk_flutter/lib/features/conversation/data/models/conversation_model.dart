import 'package:amazetalk_flutter/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel(
      {required super.success, required super.data, required super.pagination});

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      success: json["success"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : Pagination.fromJson(json["pagination"]),
    );
  }
}
