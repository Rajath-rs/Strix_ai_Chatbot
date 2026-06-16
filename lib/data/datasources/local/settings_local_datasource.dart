import 'package:hive/hive.dart';
import '../../models/settings_model.dart';
import '../../models/ai_provider_model.dart';
import '../../../core/errors/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> updateDarkMode(bool isDarkMode);
  Future<void> setCurrentProvider(String providerId);
  Future<void> saveProvider(AIProviderModel provider);
  Future<void> deleteProvider(String providerId);
  Future<List<AIProviderModel>> getAllProviders();
  Future<AIProviderModel?> getCurrentProvider();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box<SettingsModel> _settingsBox;
  final Box<AIProviderModel> _providersBox;

  static const String _settingsKey = 'settings';

  SettingsLocalDataSourceImpl(this._settingsBox, this._providersBox);

  @override
  Future<SettingsModel> getSettings() async {
    try {
      SettingsModel settings = _settingsBox.get(_settingsKey) ?? SettingsModel();
      return settings;
    } catch (e) {
      throw CacheException('Failed to get settings: $e');
    }
  }

  @override
  Future<void> updateDarkMode(bool isDarkMode) async {
    try {
      final settings = await getSettings();
      await _settingsBox.put(_settingsKey, settings.copyWith(isDarkMode: isDarkMode));
    } catch (e) {
      throw CacheException('Failed to update dark mode: $e');
    }
  }

  @override
  Future<void> setCurrentProvider(String providerId) async {
    try {
      final settings = await getSettings();
      await _settingsBox.put(_settingsKey, settings.copyWith(currentProviderId: providerId));
    } catch (e) {
      throw CacheException('Failed to set current provider: $e');
    }
  }

  @override
  Future<void> saveProvider(AIProviderModel provider) async {
    try {
      await _providersBox.put(provider.id, provider);
    } catch (e) {
      throw CacheException('Failed to save provider: $e');
    }
  }

  @override
  Future<void> deleteProvider(String providerId) async {
    try {
      await _providersBox.delete(providerId);
    } catch (e) {
      throw CacheException('Failed to delete provider: $e');
    }
  }

  @override
  Future<List<AIProviderModel>> getAllProviders() async {
    try {
      return _providersBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get providers: $e');
    }
  }

  @override
  Future<AIProviderModel?> getCurrentProvider() async {
    try {
      final settings = await getSettings();
      if (settings.currentProviderId == null) return null;
      return _providersBox.get(settings.currentProviderId);
    } catch (e) {
      throw CacheException('Failed to get current provider: $e');
    }
  }
}
