import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_list_state.freezed.dart';

@freezed
sealed class MessageListState with _$MessageListState {
  const factory MessageListState.initial() = MessageListInitial;
  const factory MessageListState.loading() = MessageListLoading;

  /// `messages` is newest-first. `transientFailure` is a dismissible error
  /// (e.g. a snackbar) that does not replace the visible list.
  const factory MessageListState.loaded({
    required List<Message> messages,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? transientFailure,
  }) = MessageListLoaded;

  const factory MessageListState.error(Failure failure) = MessageListError;
}
