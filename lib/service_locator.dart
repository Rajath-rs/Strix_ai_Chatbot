import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// Core
import 'core/network/network_info.dart';

// Data - Data Sources
import 'data/datasources/local/conversation_local_datasource.dart';
import 'data/datasources/local/message_local_datasource.dart';
import 'data/datasources/local/settings_local_datasource.dart';
import 'data/datasources/remote/ai_client.dart';
import 'data/models/conversation_model.dart';
import 'data/models/message_model.dart';
import 'data/models/ai_provider_model.dart';
import 'data/models/settings_model.dart';

// Data - Repositories
import 'data/repositories/conversation_repository_impl.dart';
import 'data/repositories/message_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/ai_repository_impl.dart';

// Domain - Repositories
import 'domain/repositories/conversation_repository.dart';
import 'domain/repositories/message_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/ai_repository.dart';

// Domain - Use Cases
import 'domain/usecases/conversation_usecases.dart';
import 'domain/usecases/message_usecases.dart';
import 'domain/usecases/settings_usecases.dart';
import 'domain/usecases/ai_usecases.dart';
import 'domain/usecases/ai_stream_usecase.dart';


// Presentation - BLoCs
import 'presentation/blocs/chat/chat_bloc.dart';
import 'presentation/blocs/conversation/conversation_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl());

  // Data Sources
  final conversationBox = Hive.box<ConversationModel>('conversations');
  final messageBox = Hive.box<MessageModel>('messages');
  final providersBox = Hive.box<AIProviderModel>('providers');
  final settingsBox = Hive.box<SettingsModel>('settings');

  getIt.registerSingleton<ConversationLocalDataSource>(
    ConversationLocalDataSourceImpl(conversationBox),
  );

  getIt.registerSingleton<MessageLocalDataSource>(
    MessageLocalDataSourceImpl(messageBox),
  );

  getIt.registerSingleton<SettingsLocalDataSource>(
    SettingsLocalDataSourceImpl(settingsBox, providersBox),
  );

  getIt.registerSingleton<AIClient>(
    AIClientImpl(http.Client()),
  );

  // Repositories
  getIt.registerSingleton<ConversationRepository>(
    ConversationRepositoryImpl(getIt<ConversationLocalDataSource>()),
  );

  getIt.registerSingleton<MessageRepository>(
    MessageRepositoryImpl(getIt<MessageLocalDataSource>()),
  );

  getIt.registerSingleton<SettingsRepository>(
    SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );

  getIt.registerSingleton<AIRepository>(
    AIRepositoryImpl(getIt<AIClient>()),
  );

  // Use Cases
  getIt.registerSingleton<GetAllConversationsUseCase>(
    GetAllConversationsUseCase(getIt<ConversationRepository>()),
  );
  getIt.registerSingleton<GetConversationByIdUseCase>(
    GetConversationByIdUseCase(getIt<ConversationRepository>()),
  );
  getIt.registerSingleton<CreateConversationUseCase>(
    CreateConversationUseCase(getIt<ConversationRepository>()),
  );
  getIt.registerSingleton<DeleteConversationUseCase>(
    DeleteConversationUseCase(getIt<ConversationRepository>()),
  );
  getIt.registerSingleton<UpdateConversationUseCase>(
    UpdateConversationUseCase(getIt<ConversationRepository>()),
  );

  getIt.registerSingleton<GetMessagesByConversationIdUseCase>(
    GetMessagesByConversationIdUseCase(getIt<MessageRepository>()),
  );
  getIt.registerSingleton<SaveMessageUseCase>(
    SaveMessageUseCase(getIt<MessageRepository>()),
  );
  getIt.registerSingleton<DeleteMessagesByConversationIdUseCase>(
    DeleteMessagesByConversationIdUseCase(getIt<MessageRepository>()),
  );

  getIt.registerSingleton<IsDarkModeUseCase>(
    IsDarkModeUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerSingleton<SetDarkModeUseCase>(
    SetDarkModeUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerSingleton<SetCurrentProviderUseCase>(
    SetCurrentProviderUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerSingleton<GetCurrentProviderUseCase>(
    GetCurrentProviderUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerSingleton<GetAllProvidersUseCase>(
    GetAllProvidersUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerSingleton<SaveProviderUseCase>(
    SaveProviderUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerSingleton<DeleteProviderUseCase>(
    DeleteProviderUseCase(getIt<SettingsRepository>()),
  );

  getIt.registerSingleton<SendMessageToAIUseCase>(
    SendMessageToAIUseCase(getIt<AIRepository>()),
  );

  getIt.registerSingleton<StreamMessageToAIUseCase>(
    StreamMessageToAIUseCase(getIt<AIRepository>()),
  );


  // BLoCs
  getIt.registerSingleton<ChatBloc>(
    ChatBloc(
      saveMessageUseCase: getIt<SaveMessageUseCase>(),
      getMessagesByConversationIdUseCase:
          getIt<GetMessagesByConversationIdUseCase>(),
      sendMessageToAIUseCase: getIt<SendMessageToAIUseCase>(),
      streamMessageToAIUseCase: getIt<StreamMessageToAIUseCase>(),
      getCurrentProviderUseCase: getIt<GetCurrentProviderUseCase>(),
    ),

  );


  getIt.registerSingleton<ConversationBloc>(
    ConversationBloc(
      getAllConversationsUseCase: getIt<GetAllConversationsUseCase>(),
      createConversationUseCase: getIt<CreateConversationUseCase>(),
      deleteConversationUseCase: getIt<DeleteConversationUseCase>(),
      getConversationByIdUseCase: getIt<GetConversationByIdUseCase>(),
      deleteMessagesByConversationIdUseCase: getIt<DeleteMessagesByConversationIdUseCase>(),
    ),
  );

  getIt.registerSingleton<SettingsBloc>(
    SettingsBloc(
      getAllProvidersUseCase: getIt<GetAllProvidersUseCase>(),
      getCurrentProviderUseCase: getIt<GetCurrentProviderUseCase>(),
      saveProviderUseCase: getIt<SaveProviderUseCase>(),
      setCurrentProviderUseCase: getIt<SetCurrentProviderUseCase>(),
      deleteProviderUseCase: getIt<DeleteProviderUseCase>(),
    ),
  );

  getIt.registerSingleton<ThemeBloc>(
    ThemeBloc(
      isDarkModeUseCase: getIt<IsDarkModeUseCase>(),
      setDarkModeUseCase: getIt<SetDarkModeUseCase>(),
    ),
  );
}
