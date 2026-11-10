import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/utils/bloc_transformers.dart';
import 'package:xchat/features/messaging/domain/usecases/draft_usecases.dart';
import 'package:xchat/features/messaging/domain/usecases/message_usecases.dart';
import 'package:xchat/features/messaging/domain/usecases/send_message.dart';
import 'package:xchat/features/messaging/presentation/bloc/composer/message_composer_event.dart';
import 'package:xchat/features/messaging/presentation/bloc/composer/message_composer_state.dart';

/// Owns everything the user is *preparing* to send in ONE conversation:
/// text, reply target, edit mode, attachments and the draft.
/// It knows nothing about the message list.
class MessageComposerBloc extends Bloc<MessageComposerEvent, MessageComposerState> {
  MessageComposerBloc({
    required this.conversationId,
    required this.senderId,
    required SendMessage sendMessage,
    required EditMessage editMessage,
    required GetDraft getDraft,
    required SaveDraft saveDraft,
    required ClearDraft clearDraft,
    this.draftDebounce = const Duration(milliseconds: 500),
  }) : _sendMessage = sendMessage,
       _editMessage = editMessage,
       _getDraft = getDraft,
       _saveDraft = saveDraft,
       _clearDraft = clearDraft,
       super(const MessageComposerState()) {
    on<ComposerStarted>(_onStarted);
    on<ComposerTextChanged>(_onTextChanged);
    on<ComposerDraftFlushRequested>(_onDraftFlush, transformer: debounced(draftDebounce));
    on<ComposerReplySet>((e, emit) => emit(state.copyWith(replyTo: e.message)));
    on<ComposerReplyCleared>((e, emit) => emit(state.copyWith(clearReplyTo: true)));
    on<ComposerEditStarted>(_onEditStarted);
    on<ComposerEditCancelled>(_onEditCancelled);
    on<ComposerAttachmentAdded>(
      (e, emit) => emit(state.copyWith(attachments: [...state.attachments, e.attachment])),
    );
    on<ComposerAttachmentRemoved>(
      (e, emit) => emit(
        state.copyWith(
          attachments: state.attachments.where((a) => a.id != e.attachmentId).toList(),
        ),
      ),
    );
    on<ComposerSendPressed>(_onSendPressed, transformer: droppable());
    on<ComposerFailureDismissed>((e, emit) => emit(state.copyWith(clearFailure: true)));
  }

  final String conversationId;
  final String senderId;
  final Duration draftDebounce;
  final SendMessage _sendMessage;
  final EditMessage _editMessage;
  final GetDraft _getDraft;
  final SaveDraft _saveDraft;
  final ClearDraft _clearDraft;

  Future<void> _onStarted(ComposerStarted event, Emitter<MessageComposerState> emit) async {
    final result = await _getDraft(conversationId);
    result.fold((_) {}, (draft) {
      if (draft != null && state.text.isEmpty) emit(state.copyWith(text: draft.text));
    });
  }

  void _onTextChanged(ComposerTextChanged event, Emitter<MessageComposerState> emit) {
    emit(state.copyWith(text: event.text));
    if (!state.isEditing) add(const MessageComposerEvent.draftFlushRequested());
  }

  Future<void> _onDraftFlush(
    ComposerDraftFlushRequested event,
    Emitter<MessageComposerState> emit,
  ) async {
    if (state.isEditing) return;
    await _saveDraft(SaveDraftParams(conversationId: conversationId, text: state.text));
  }

  void _onEditStarted(ComposerEditStarted event, Emitter<MessageComposerState> emit) {
    emit(
      state.copyWith(
        editing: event.message,
        textBeforeEdit: state.isEditing ? state.textBeforeEdit : state.text,
        text: event.message.text ?? '',
        clearReplyTo: true,
        attachments: const [],
        clearFailure: true,
      ),
    );
  }

  void _onEditCancelled(ComposerEditCancelled event, Emitter<MessageComposerState> emit) {
    if (!state.isEditing) return;
    emit(
      state.copyWith(
        clearEditing: true,
        text: state.textBeforeEdit ?? '',
        clearTextBeforeEdit: true,
      ),
    );
  }

  Future<void> _onSendPressed(ComposerSendPressed event, Emitter<MessageComposerState> emit) async {
    if (!state.canSend) return;
    emit(state.copyWith(isSending: true, clearFailure: true));

    final editing = state.editing;
    final Failure? failure = editing != null
        ? (await _editMessage(
            EditMessageParams(messageId: editing.id, newText: state.text),
          )).fold<Failure?>((f) => f, (_) => null)
        : (await _sendMessage(
            SendMessageParams(
              conversationId: conversationId,
              senderId: senderId,
              text: state.text,
              attachments: state.attachments,
              replyToId: state.replyTo?.id,
            ),
          )).fold<Failure?>((f) => f, (_) => null);

    if (failure != null) {
      emit(state.copyWith(isSending: false, failure: failure));
      return;
    }
    await _clearDraft(conversationId);
    emit(const MessageComposerState());
  }
}
