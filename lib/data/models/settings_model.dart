import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 3)
class SettingsModel {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final String? currentProviderId;

  SettingsModel({
    this.isDarkMode = false,
    this.currentProviderId,
  });

  SettingsModel copyWith({
    bool? isDarkMode,
    String? currentProviderId,
  }) => SettingsModel(
    isDarkMode: isDarkMode ?? this.isDarkMode,
    currentProviderId: currentProviderId ?? this.currentProviderId,
  );
}
