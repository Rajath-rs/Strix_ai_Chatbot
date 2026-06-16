import 'package:hive/hive.dart';
import '../../domain/entities/ai_provider.dart';

part 'ai_provider_model.g.dart';

@HiveType(typeId: 2)
class AIProviderModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String providerName;

  @HiveField(2)
  final String baseUrl;

  @HiveField(3)
  final String model;

  @HiveField(4)
  final String apiKey;

  AIProviderModel({
    required this.id,
    required this.providerName,
    required this.baseUrl,
    required this.model,
    required this.apiKey,
  });

  AIProvider toEntity() => AIProvider(
    id: id,
    providerName: providerName,
    baseUrl: baseUrl,
    model: model,
    apiKey: apiKey,
  );

  factory AIProviderModel.fromEntity(AIProvider entity) => AIProviderModel(
    id: entity.id,
    providerName: entity.providerName,
    baseUrl: entity.baseUrl,
    model: entity.model,
    apiKey: entity.apiKey,
  );

  factory AIProviderModel.fromJson(Map<String, dynamic> json) => AIProviderModel(
    id: json['id'] as String,
    providerName: json['providerName'] as String,
    baseUrl: json['baseUrl'] as String,
    model: json['model'] as String,
    apiKey: json['apiKey'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'providerName': providerName,
    'baseUrl': baseUrl,
    'model': model,
    'apiKey': apiKey,
  };

  AIProviderModel copyWith({
    String? id,
    String? providerName,
    String? baseUrl,
    String? model,
    String? apiKey,
  }) => AIProviderModel(
    id: id ?? this.id,
    providerName: providerName ?? this.providerName,
    baseUrl: baseUrl ?? this.baseUrl,
    model: model ?? this.model,
    apiKey: apiKey ?? this.apiKey,
  );
}
