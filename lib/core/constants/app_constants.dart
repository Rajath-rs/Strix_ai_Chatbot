class AppConstants {
  // API
  static const String defaultBaseUrl = 'https://api.openai.com/v1';
  static const String defaultModel = 'gpt-3.5-turbo';
  static const int apiTimeoutSeconds = 30;

  // Hive
  static const String conversationsBoxName = 'conversations';
  static const String messagesBoxName = 'messages';
  static const String providersBoxName = 'providers';
  static const String settingsBoxName = 'settings';

  // Messages
  static const String userRole = 'user';
  static const String assistantRole = 'assistant';

  // Error Messages
  static const String networkErrorMessage = 'Network error occurred. Please check your connection.';
  static const String serverErrorMessage = 'Server error occurred. Please try again.';
  static const String invalidApiKeyMessage = 'Invalid API key. Please check your settings.';
  static const String emptyMessageMessage = 'Message cannot be empty.';
  static const String noProvidersMessage = 'No AI providers configured.';
  static const String loadingConversationsMessage = 'Loading conversations...';
  static const String sendingMessageMessage = 'Sending message...';
}
