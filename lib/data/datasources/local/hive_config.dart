import 'package:hive_flutter/hive_flutter.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../models/ai_provider_model.dart';
import '../../models/settings_model.dart';
import '../../../core/constants/app_constants.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(ConversationModelAdapter().typeId)) {
    Hive.registerAdapter(ConversationModelAdapter());
  }
  if (!Hive.isAdapterRegistered(MessageModelAdapter().typeId)) {
    Hive.registerAdapter(MessageModelAdapter());
  }
  if (!Hive.isAdapterRegistered(AIProviderModelAdapter().typeId)) {
    Hive.registerAdapter(AIProviderModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SettingsModelAdapter().typeId)) {
    Hive.registerAdapter(SettingsModelAdapter());
  }

  await Hive.openBox<ConversationModel>(AppConstants.conversationsBoxName);
  await Hive.openBox<MessageModel>(AppConstants.messagesBoxName);
  await Hive.openBox<AIProviderModel>(AppConstants.providersBoxName);
  await Hive.openBox<SettingsModel>(AppConstants.settingsBoxName);
}

Future<void> closeHive() async {
  await Hive.close();
}
