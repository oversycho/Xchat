import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:xchat/features/messaging/domain/usecases/message_usecases.dart';
import 'package:xchat/features/messaging/domain/usecases/outbox_usecases.dart';
import 'package:xchat/features/messaging/presentation/bloc/message_list/message_list_event.dart';
import 'package:xchat/features/messaging/presentation/bloc/message_list/message_list_state.dart';

/// Owns the visible message list of ONE conversation (including pagination).
/// The local database is the single source of truth: every change
/// (own sends, realtime events, pagination, edits) arrives through the
/// repository stream, so there is exactly one place the list is built.
class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  MessageListBloc({
    required this.conversationId,
    required this.currentUserId,
    required WatchMessages watchMessages,
    required RefreshLatestMessages refreshLatest,
    required LoadOlderMessages loadOlder,
    required SubscribeToConversation subscribe,
    required UnsubscribeFromConversation unsubscribe,
    required DeleteMessage deleteMessage,
    required ReactToMessage reactToMessage,
    required RetryMessage retryMessage,
  }) : _watchMessages = watchMessages,
       _refreshLatest = refreshLatest,
       _loadOlder = loadOlder,
       _subscribe = subscribe,
       _unsubscribe = unsubscribe,
       _deleteMessage = deleteMessage,
       _reactToMessage = reactToMessage,
       _retryMessage = retryMessage,
       super(const MessageListState.initial()) {
    on<MessageListStarted>(_onStarted);
    on<MessageListOlderRequested>(_onOlderRequested, transformer: droppable());
    on<MessageListDeleteRequested>(_onDeleteRequested);
    on<MessageListReactionToggled>(_onReactionToggled);
    on<MessageListRetryRequested>(_onRetryRequested);
    on<MessageListSyncFailed>(_onSyncFailed);
    on<MessageListFailureDismissed>(_onFailureDismissed);
  }

  final String conversationId;
  final String currentUserId;
  final WatchMessages _watchMessages;
  final RefreshLatestMessages _refreshLatest;
  final LoadOlderMessages _loadOlder;
  final SubscribeToConversation _subscribe;
  final UnsubscribeFromConversation _unsubscribe;
  final DeleteMessage _deleteMessage;
  final ReactToMessage _reactToMessage;
  final RetryMessage _retryMessage;

  Future<void> _onStarted(MessageListStarted event, Emitter<MessageListState> emit) async {
    emit(const MessageListState.loading());
    // Realtime failures are non-fatal: catch-up on the next resync repairs the cache.
    await _subscribe(conversationId);
    unawaited(_syncInBackground());

    // Stays open for the lifetime of the bloc and cancels automatically on close.
    await emit.forEach<List<Message>>(
      _watchMessages(conversationId),
      onData: (messages) {
        final current = state;
        return current is MessageListLoaded
            ? current.copyWith(messages: messages)
            : MessageListState.loaded(messages: messages);
      },
      onError: (error, _) => MessageListState.error(UnexpectedFailure(error.toString())),
    );
  }

  Future<void> _syncInBackground() async {
    final result = await _refreshLatest(conversationId);
    result.fold((failure) {
      if (!isClosed) add(MessageListEvent.syncFailed(failure));
    }, (_) {});
  }

  Future<void> _onOlderRequested(
    MessageListOlderRequested event,
    Emitter<MessageListState> emit,
  ) async {
    final current = state;
    if (current is! MessageListLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true, clearFailure: true));
    final result = await _loadOlder(LoadOlderParams(conversationId));

    final latest = state;
    if (latest is! MessageListLoaded) return;
    result.fold(
      (failure) => emit(latest.copyWith(isLoadingMore: false, transientFailure: failure)),
      (page) => emit(latest.copyWith(isLoadingMore: false, hasMore: page.hasMore)),
    );
  }

  Future<void> _onDeleteRequested(
    MessageListDeleteRequested event,
    Emitter<MessageListState> emit,
  ) async {
    final result = await _deleteMessage(event.messageId);
    result.fold((failure) => _emitTransient(failure, emit), (_) {});
  }

  Future<void> _onReactionToggled(
    MessageListReactionToggled event,
    Emitter<MessageListState> emit,
  ) async {
    final current = state;
    if (current is! MessageListLoaded) return;

    final message = current.messages.where((m) => m.id == event.messageId).firstOrNull;
    if (message == null) return;
    final alreadyReacted = message.reactions.any(
      (r) => r.userId == currentUserId && r.emoji == event.emoji,
    );

    final result = await _reactToMessage(
      ReactToMessageParams(messageId: event.messageId, emoji: event.emoji, add: !alreadyReacted),
    );
    result.fold((failure) => _emitTransient(failure, emit), (_) {});
  }

  Future<void> _onRetryRequested(
    MessageListRetryRequested event,
    Emitter<MessageListState> emit,
  ) async {
    final result = await _retryMessage(event.messageId);
    result.fold((failure) => _emitTransient(failure, emit), (_) {});
  }

  void _onSyncFailed(MessageListSyncFailed event, Emitter<MessageListState> emit) =>
      _emitTransient(event.failure, emit);

  void _onFailureDismissed(MessageListFailureDismissed event, Emitter<MessageListState> emit) {
    final current = state;
    if (current is MessageListLoaded) emit(current.copyWith(clearFailure: true));
  }

  void _emitTransient(Failure failure, Emitter<MessageListState> emit) {
    final current = state;
    if (current is MessageListLoaded) emit(current.copyWith(transientFailure: failure));
  }

  @override
  Future<void> close() async {
    await _unsubscribe(conversationId);
    return super.close();
  }
}
