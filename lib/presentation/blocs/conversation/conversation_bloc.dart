import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/usecases/conversation_usecases.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/usecases/message_usecases.dart';
import '../../../domain/entities/conversation.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetAllConversationsUseCase getAllConversationsUseCase;
  final CreateConversationUseCase createConversationUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;
  final GetConversationByIdUseCase getConversationByIdUseCase;
  final DeleteMessagesByConversationIdUseCase deleteMessagesByConversationIdUseCase;

  ConversationBloc({
    required this.getAllConversationsUseCase,
    required this.createConversationUseCase,
    required this.deleteConversationUseCase,
    required this.getConversationByIdUseCase,
    required this.deleteMessagesByConversationIdUseCase,
  }) : super(const ConversationLoading()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<CreateConversationEvent>(_onCreateConversation);
    on<DeleteConversationEvent>(_onDeleteConversation);
    on<OpenConversationEvent>(_onOpenConversation);
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(const ConversationLoading());

    final result = await getAllConversationsUseCase(NoParams());

    result.fold(
      (failure) => emit(ConversationError(failure.message)),
      (conversations) {
        if (conversations.isEmpty) {
          emit(const ConversationEmpty());
        } else {
          emit(ConversationLoaded(conversations));
        }
      },
    );
  }

  Future<void> _onCreateConversation(
    CreateConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final newConversation = Conversation(
        id: const Uuid().v4(),
        title: event.title,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await createConversationUseCase(
        CreateConversationParams(newConversation),
      );

      result.fold(
        (failure) => emit(ConversationError(failure.message)),
        (_) async {
          // Emit created state then immediately refresh the list so the UI updates
          // even if the screen is navigated away and back.
          emit(ConversationCreated(newConversation));

          final refreshResult = await getAllConversationsUseCase(NoParams());
          refreshResult.fold(
            (failure) => emit(ConversationError(failure.message)),
            (conversations) {
              if (conversations.isEmpty) {
                emit(const ConversationEmpty());
              } else {
                emit(ConversationLoaded(conversations));
              }
            },
          );
        },
      );
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }


  Future<void> _onDeleteConversation(
    DeleteConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      await deleteMessagesByConversationIdUseCase(
        DeleteMessagesByConversationIdParams(event.conversationId),
      );

      final result = await deleteConversationUseCase(
        DeleteConversationParams(event.conversationId),
      );

      result.fold(
        (failure) => emit(ConversationError(failure.message)),
        (_) async {
          emit(ConversationDeleted(event.conversationId));

          final refreshResult = await getAllConversationsUseCase(NoParams());
          refreshResult.fold(
            (failure) => emit(ConversationError(failure.message)),
            (conversations) {
              if (conversations.isEmpty) {
                emit(const ConversationEmpty());
              } else {
                emit(ConversationLoaded(conversations));
              }
            },
          );
        },
      );
    } catch (e) {
      emit(ConversationError(e.toString()));
    }
  }


  Future<void> _onOpenConversation(
    OpenConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    final result = await getConversationByIdUseCase(
      GetConversationByIdParams(event.conversationId),
    );

    result.fold(
      (failure) => emit(ConversationError(failure.message)),
      (conversation) => emit(ConversationOpened(conversation)),
    );
  }
}
