// class ConversationEntity {
//   final String id;
//   final String conversation;
//   final String senderId;
//   final String senderName;
//   final String message;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   ConversationEntity(
//       {required this.id,
//       required this.conversation,
//       required this.senderId,
//       required this.senderName,
//       required this.message,
//       required this.createdAt,
//       required this.updatedAt});
// }

class ConversationEntity {
  ConversationEntity({
    required this.success,
    required this.data,
    required this.pagination,
  });

  final bool? success;
  final List<Datum> data;
  final Pagination? pagination;

  factory ConversationEntity.fromJson(Map<String, dynamic> json) {
    return ConversationEntity(
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

class Datum {
  Datum({
    required this.conversationId,
    required this.text,
    required this.sender,
    required this.createdAt,
  });

  final String? conversationId;
  final String? text;
  final Sender? sender;
  final DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      conversationId: json["conversationId"],
      text: json["text"],
      sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }
}

class Sender {
  Sender({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json["_id"],
      name: json["name"],
    );
  }
}

class Pagination {
  Pagination({
    required this.totalPages,
    required this.currentPage,
  });

  final int totalPages;
  final int currentPage;

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: json["totalPages"],
      currentPage: json["currentPage"],
    );
  }
}
