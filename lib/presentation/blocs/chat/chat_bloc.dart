import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/message_usecases.dart';
import '../../../domain/usecases/ai_usecases.dart';
import '../../../domain/usecases/ai_stream_usecase.dart';
import '../../../domain/usecases/settings_usecases.dart';

import '../../../domain/entities/message.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/usecase/usecase.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SaveMessageUseCase saveMessageUseCase;
  final GetMessagesByConversationIdUseCase getMessagesByConversationIdUseCase;
  final SendMessageToAIUseCase sendMessageToAIUseCase;
  final StreamMessageToAIUseCase streamMessageToAIUseCase;
  final GetCurrentProviderUseCase getCurrentProviderUseCase;



  bool _isProcessing = false;

  String _mapFailureMessage(String failureMessage) {
    final msg = failureMessage.toLowerCase();

    if (msg.contains('authentication')) {
      return 'Authentication failed. Check your API key in Settings.';
    }
    if (msg.contains('rate limit') || msg.contains('429')) {
      return 'Rate limit exceeded. Please try again later.';
    }
    if (msg.contains('network')) {
      return 'Network error. Please check your connection and try again.';
    }
    if (msg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    return failureMessage;
  }

  ChatBloc({
    required this.saveMessageUseCase,
    required this.getMessagesByConversationIdUseCase,
    required this.sendMessageToAIUseCase,
    required this.streamMessageToAIUseCase,
    required this.getCurrentProviderUseCase,
  }) : super(const ChatInitial()) {


    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }





  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatMessagesLoading());

    final result = await getMessagesByConversationIdUseCase(
      GetMessagesByConversationIdParams(event.conversationId),
    );

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatMessagesReady(messages: messages, isWaitingForResponse: false)),
    );
  }


  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    if (_isProcessing) return;

    final trimmed = event.messageContent.trim();
    if (trimmed.isEmpty) {
      emit(const ChatError(AppConstants.emptyMessageMessage));
      return;
    }

    _isProcessing = true;
    emit(const ChatLoading());

    try {


      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: event.conversationId,
        role: AppConstants.userRole,
        content: trimmed,
        timestamp: DateTime.now(),
      );


      await saveMessageUseCase(SaveMessageParams(userMessage));

      // Immediately update UI with the newly persisted user message.
      final historyResultAfterUser = await getMessagesByConversationIdUseCase(
        GetMessagesByConversationIdParams(event.conversationId),
      );

      await historyResultAfterUser.fold(
        (failure) async => emit(ChatError(failure.message)),
        (historyMessages) async {
          emit(
            ChatMessagesReady(
              messages: [
                ...historyMessages,
              ],
              isWaitingForResponse: true,
            ),
          );
        },
      );





      final providerResult = await getCurrentProviderUseCase(NoParams());

      final provider = providerResult.fold(
        (failure) => null,
        (provider) => provider,
      );


      if (provider == null) {
        emit(const ChatError(AppConstants.noProvidersMessage));
        return;
      }

      final historyResult = await getMessagesByConversationIdUseCase(
        GetMessagesByConversationIdParams(event.conversationId),
      );

      final historyMessages = historyResult.fold(
        (failure) => <Message>[],
        (messages) => messages,
      );

      final messagesForAI = [
        ...historyMessages.map(
          (m) => {'role': m.role, 'content': m.content},
        ),
        {'role': AppConstants.userRole, 'content': trimmed},
      ];



      // Create an assistant message placeholder and update it incrementally
      // as the provider streams tokens.
      final assistantMessageId = DateTime.now().millisecondsSinceEpoch.toString();
      final assistantTimestamp = DateTime.now();
      var buffer = StringBuffer();

      // Emit placeholder using current history + assistant buffer (empty for now).
      emit(
        ChatMessagesReady(
          messages: [
            ...historyMessages,
            Message(
              id: assistantMessageId,
              conversationId: event.conversationId,
              role: AppConstants.assistantRole,
              content: buffer.toString(),
              timestamp: assistantTimestamp,
            ),
          ],
          isWaitingForResponse: true,
        ),
      );

      final streamResult = await streamMessageToAIUseCase(
        StreamMessageToAIParams(
          baseUrl: provider.baseUrl,
          apiKey: provider.apiKey,
          model: provider.model,
          messages: messagesForAI,
        ),
      );

      await streamResult.fold(
        (failure) async {
          emit(ChatError(_mapFailureMessage(failure.message)));
        },
        (stream) async {
          await for (final eitherToken in stream) {
            await eitherToken.fold(
              (failure) async {
                emit(ChatError(_mapFailureMessage(failure.message)));
              },
              (token) async {
                buffer.write(token);

                final updatedMessages = [
                  ...historyMessages,
                  Message(
                    id: assistantMessageId,
                    conversationId: event.conversationId,
                    role: AppConstants.assistantRole,
                    content: buffer.toString(),
                    timestamp: assistantTimestamp,
                  ),
                ];

                emit(
                  ChatMessagesReady(
                    messages: updatedMessages,
                    isWaitingForResponse: true,
                  ),
                );
              },
            );
          }
        },
      );

      // Persist final assistant message.
      final assistantMessage = Message(
        id: assistantMessageId,
        conversationId: event.conversationId,
        role: AppConstants.assistantRole,
        content: buffer.toString(),
        timestamp: assistantTimestamp,
      );

      await saveMessageUseCase(SaveMessageParams(assistantMessage));

      final historyResultAfterAssistant = await getMessagesByConversationIdUseCase(
        GetMessagesByConversationIdParams(event.conversationId),
      );

      historyResultAfterAssistant.fold(
        (failure) => emit(ChatError(failure.message)),
        (updatedMessages) => emit(
          ChatMessagesReady(
            messages: updatedMessages,
            isWaitingForResponse: false,
          ),
        ),
      );



    } catch (e) {
      emit(ChatError('Error: ${e.toString()}'));
    } finally {
      _isProcessing = false;
    }
  }


  Future<void> _onClearChat(ClearChatEvent event, Emitter<ChatState> emit) async {
    emit(const ChatInitial());
  }

}
