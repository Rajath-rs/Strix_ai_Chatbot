// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIProviderModelAdapter extends TypeAdapter<AIProviderModel> {
  @override
  final int typeId = 2;

  @override
  AIProviderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIProviderModel(
      id: fields[0] as String,
      providerName: fields[1] as String,
      baseUrl: fields[2] as String,
      model: fields[3] as String,
      apiKey: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AIProviderModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.providerName)
      ..writeByte(2)
      ..write(obj.baseUrl)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.apiKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIProviderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
