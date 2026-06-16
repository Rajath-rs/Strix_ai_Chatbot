import 'package:hive/hive.dart';
import '../../domain/entities/conversation.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: 0)
class ConversationModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  ConversationModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  Conversation toEntity() => Conversation(
    id: id,
    title: title,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ConversationModel.fromEntity(Conversation entity) => ConversationModel(
    id: entity.id,
    title: entity.title,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
    id: json['id'] as String,
    title: json['title'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
