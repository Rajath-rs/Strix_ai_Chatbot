import 'package:equatable/equatable.dart';

class AIProvider extends Equatable {
  final String id;
  final String providerName;
  final String baseUrl;
  final String model;
  final String apiKey;

  const AIProvider({
    required this.id,
    required this.providerName,
    required this.baseUrl,
    required this.model,
    required this.apiKey,
  });

  @override
  List<Object?> get props => [id, providerName, baseUrl, model, apiKey];
}
