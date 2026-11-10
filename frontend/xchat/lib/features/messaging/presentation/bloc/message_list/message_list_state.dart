import 'package:equatable/equatable.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';

sealed class MessageListState extends Equatable {
  const MessageListState();

  const factory MessageListState.initial() = MessageListInitial;
  const factory MessageListState.loading() = MessageListLoading;
  const factory MessageListState.loaded({
    required List<Message> messages,
    bool hasMore,
    bool isLoadingMore,
    Failure? transientFailure,
  }) = MessageListLoaded;
  const factory MessageListState.error(Failure failure) = MessageListError;

  @override
  List<Object?> get props => const [];
}

final class MessageListInitial extends MessageListState {
  const MessageListInitial();
}

final class MessageListLoading extends MessageListState {
  const MessageListLoading();
}

/// `messages` is newest-first. `transientFailure` is a dismissible error
/// (e.g. a snackbar) that does not replace the visible list.
final class MessageListLoaded extends MessageListState {
  const MessageListLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.transientFailure,
  });

  final List<Message> messages;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? transientFailure;

  MessageListLoaded copyWith({
    List<Message>? messages,
    bool? hasMore,
    bool? isLoadingMore,
    Failure? transientFailure,
    bool clearFailure = false,
  }) => MessageListLoaded(
    messages: messages ?? this.messages,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    transientFailure: clearFailure ? null : (transientFailure ?? this.transientFailure),
  );

  @override
  List<Object?> get props => [messages, hasMore, isLoadingMore, transientFailure];
}

final class MessageListError extends MessageListState {
  const MessageListError(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
