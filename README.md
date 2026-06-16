# Strix AI Chatbot

A production-oriented AI Chat Assistant mobile application built with Flutter, demonstrating clean architecture principles, Bloc state management, and local data persistence.

## Features

### Core Features
- **Conversation Management**: Create, view, open, and delete conversations
- **Modern Chat Interface**: Message list, message composer with multiline support
- **AI Integration**: Support for multiple AI providers with configurable settings
- **Local Persistence**: All conversations and messages stored locally using Hive
- **Error Handling**: Comprehensive error handling for network, server, and validation errors
- **Bloc State Management**: Clean separation of concerns with ChatBloc, ConversationBloc, SettingsBloc, and ThemeBloc

### Bonus Features
- **Dark Mode**: Light and dark themes with persistent user preference
- **Markdown Rendering**: AI responses rendered with markdown formatting support

## Architecture

### Layered Architecture
The application follows a clean architecture pattern with clear separation of concerns across three main layers:
- Presentation Layer (UI, Screens, Widgets, BLoCs)
- Domain Layer (Entities, Abstract Repositories, Use Cases)
- Data Layer (Models, Data Sources, Repository Implementations)

### Bloc Architecture

**ChatBloc**: Handles message sending and receiving AI responses
- Events: SendMessageEvent, ClearChatEvent
- States: ChatInitial, ChatLoading, MessageSent, AssistantResponseReceived, ChatError

**ConversationBloc**: Manages conversation CRUD operations
- Events: LoadConversationsEvent, CreateConversationEvent, DeleteConversationEvent, OpenConversationEvent
- States: ConversationLoading, ConversationLoaded, ConversationEmpty, ConversationCreated, ConversationDeleted, ConversationOpened, ConversationError

**SettingsBloc**: Manages AI provider configuration
- Events: LoadSettingsEvent, UpdateProviderEvent, SetCurrentProviderEvent, DeleteProviderEvent
- States: SettingsLoading, SettingsLoaded, ProviderUpdated, CurrentProviderSet, ProviderDeleted, SettingsError

**ThemeBloc**: Manages application theme (light/dark mode)
- Events: LoadThemeEvent, ToggleThemeEvent, SetThemeEvent
- States: ThemeLoading, ThemeLoaded, ThemeError

## Technology Stack

- **Framework**: Flutter & Dart
- **State Management**: BLoC (flutter_bloc 8.1.6)
- **Local Database**: Hive 2.2.3
- **HTTP Client**: http 1.2.0
- **JSON Serialization**: json_serializable 6.8.0
- **Dependency Injection**: GetIt 7.6.0
- **Markdown Rendering**: flutter_markdown 0.6.14
- **Utilities**: uuid, intl, equatable, dartz

## Project Structure

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── usecase/
├── data/                    # Data Layer
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/                  # Domain Layer
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/            # Presentation Layer
│   ├── blocs/
│   ├── screens/
│   ├── widgets/
│   └── theme/
├── service_locator.dart
└── main.dart
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.11.5+)
- Dart SDK
- Android/iOS development environment

### Installation

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Run `flutter run`

## Configuration

### AI Provider Setup

1. Open Settings from the app
2. Tap "Add Provider"
3. Configure:
   - Provider Name (e.g., "OpenAI")
   - Base URL (e.g., https://api.openai.com/v1)
   - Model (e.g., gpt-3.5-turbo)
   - API Key

### Supported Providers
- OpenAI: https://api.openai.com/v1
- Gemini: https://generativelanguage.googleapis.com/v1
- OpenRouter: https://openrouter.ai/api/v1
- LM Studio: http://localhost:1234/v1
- Any OpenAI-compatible endpoint

## Local Storage Design

### Hive Boxes

**conversations**: Stores conversation metadata
- id (UUID)
- title
- createdAt, updatedAt

**messages**: Stores all messages
- id (UUID)
- conversationId
- role ("user" or "assistant")
- content
- timestamp

**providers**: Stores AI provider configurations
- id
- providerName
- baseUrl
- model
- apiKey

**settings**: Stores app settings
- isDarkMode
- currentProviderId

## Usage

### Creating a Conversation
1. Tap "+" button
2. Enter conversation title
3. Tap "Create"

### Sending a Message
1. Open a conversation
2. Type message in composer
3. Tap send button
4. Wait for AI response

### Switching Theme
1. Tap theme icon in app bar
2. Preference is automatically saved

## Error Handling

Handles:
- Network failures
- Timeout errors
- Invalid API responses
- Authentication failures
- Rate limit errors
- Validation errors

All errors display user-friendly messages with retry options.

## Performance

- Local-first architecture minimizes network calls
- Efficient message list scrolling
- Lazy loading of conversations
- Cached message storage

## Future Enhancements

- Streaming responses
- Voice input/output
- Conversation search
- Message export (PDF/text)
- Cloud sync (optional)
- Multi-language support
- Push notifications

## Security

- API keys stored locally using Hive
- All API calls use HTTPS
- No credentials logged
- Local-first data storage

## Troubleshooting

### App crashes on startup
- Run `flutter clean`
- Ensure Hive initialization completes

### Messages not sending
- Verify AI provider is configured
- Check API key validity
- Verify network connection

### Theme not persisting
- Ensure SettingsBloc initialization
- Check Hive permissions

## License

Provided for educational and evaluation purposes.
