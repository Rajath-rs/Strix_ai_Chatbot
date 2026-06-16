import 'package:hive/hive.dart';
import '../../domain/entities/message.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
class MessageModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String conversationId;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Message toEntity() => Message(
    id: id,
    conversationId: conversationId,
    role: role,
    content: content,
    timestamp: timestamp,
  );

  factory MessageModel.fromEntity(Message entity) => MessageModel(
    id: entity.id,
    conversationId: entity.conversationId,
    role: entity.role,
    content: entity.content,
    timestamp: entity.timestamp,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] as String,
    conversationId: json['conversationId'] as String,
    role: json['role'] as String,
    content: json['content'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
}
