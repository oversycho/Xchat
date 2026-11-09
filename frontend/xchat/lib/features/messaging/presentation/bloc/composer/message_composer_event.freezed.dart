// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_composer_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageComposerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageComposerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent()';
}


}

/// @nodoc
class $MessageComposerEventCopyWith<$Res>  {
$MessageComposerEventCopyWith(MessageComposerEvent _, $Res Function(MessageComposerEvent) __);
}


/// Adds pattern-matching-related methods to [MessageComposerEvent].
extension MessageComposerEventPatterns on MessageComposerEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ComposerStarted value)?  started,TResult Function( ComposerTextChanged value)?  textChanged,TResult Function( ComposerReplySet value)?  replySet,TResult Function( ComposerReplyCleared value)?  replyCleared,TResult Function( ComposerEditStarted value)?  editStarted,TResult Function( ComposerEditCancelled value)?  editCancelled,TResult Function( ComposerAttachmentAdded value)?  attachmentAdded,TResult Function( ComposerAttachmentRemoved value)?  attachmentRemoved,TResult Function( ComposerSendPressed value)?  sendPressed,TResult Function( ComposerFailureDismissed value)?  failureDismissed,TResult Function( ComposerDraftFlushRequested value)?  draftFlushRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ComposerStarted() when started != null:
return started(_that);case ComposerTextChanged() when textChanged != null:
return textChanged(_that);case ComposerReplySet() when replySet != null:
return replySet(_that);case ComposerReplyCleared() when replyCleared != null:
return replyCleared(_that);case ComposerEditStarted() when editStarted != null:
return editStarted(_that);case ComposerEditCancelled() when editCancelled != null:
return editCancelled(_that);case ComposerAttachmentAdded() when attachmentAdded != null:
return attachmentAdded(_that);case ComposerAttachmentRemoved() when attachmentRemoved != null:
return attachmentRemoved(_that);case ComposerSendPressed() when sendPressed != null:
return sendPressed(_that);case ComposerFailureDismissed() when failureDismissed != null:
return failureDismissed(_that);case ComposerDraftFlushRequested() when draftFlushRequested != null:
return draftFlushRequested(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ComposerStarted value)  started,required TResult Function( ComposerTextChanged value)  textChanged,required TResult Function( ComposerReplySet value)  replySet,required TResult Function( ComposerReplyCleared value)  replyCleared,required TResult Function( ComposerEditStarted value)  editStarted,required TResult Function( ComposerEditCancelled value)  editCancelled,required TResult Function( ComposerAttachmentAdded value)  attachmentAdded,required TResult Function( ComposerAttachmentRemoved value)  attachmentRemoved,required TResult Function( ComposerSendPressed value)  sendPressed,required TResult Function( ComposerFailureDismissed value)  failureDismissed,required TResult Function( ComposerDraftFlushRequested value)  draftFlushRequested,}){
final _that = this;
switch (_that) {
case ComposerStarted():
return started(_that);case ComposerTextChanged():
return textChanged(_that);case ComposerReplySet():
return replySet(_that);case ComposerReplyCleared():
return replyCleared(_that);case ComposerEditStarted():
return editStarted(_that);case ComposerEditCancelled():
return editCancelled(_that);case ComposerAttachmentAdded():
return attachmentAdded(_that);case ComposerAttachmentRemoved():
return attachmentRemoved(_that);case ComposerSendPressed():
return sendPressed(_that);case ComposerFailureDismissed():
return failureDismissed(_that);case ComposerDraftFlushRequested():
return draftFlushRequested(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ComposerStarted value)?  started,TResult? Function( ComposerTextChanged value)?  textChanged,TResult? Function( ComposerReplySet value)?  replySet,TResult? Function( ComposerReplyCleared value)?  replyCleared,TResult? Function( ComposerEditStarted value)?  editStarted,TResult? Function( ComposerEditCancelled value)?  editCancelled,TResult? Function( ComposerAttachmentAdded value)?  attachmentAdded,TResult? Function( ComposerAttachmentRemoved value)?  attachmentRemoved,TResult? Function( ComposerSendPressed value)?  sendPressed,TResult? Function( ComposerFailureDismissed value)?  failureDismissed,TResult? Function( ComposerDraftFlushRequested value)?  draftFlushRequested,}){
final _that = this;
switch (_that) {
case ComposerStarted() when started != null:
return started(_that);case ComposerTextChanged() when textChanged != null:
return textChanged(_that);case ComposerReplySet() when replySet != null:
return replySet(_that);case ComposerReplyCleared() when replyCleared != null:
return replyCleared(_that);case ComposerEditStarted() when editStarted != null:
return editStarted(_that);case ComposerEditCancelled() when editCancelled != null:
return editCancelled(_that);case ComposerAttachmentAdded() when attachmentAdded != null:
return attachmentAdded(_that);case ComposerAttachmentRemoved() when attachmentRemoved != null:
return attachmentRemoved(_that);case ComposerSendPressed() when sendPressed != null:
return sendPressed(_that);case ComposerFailureDismissed() when failureDismissed != null:
return failureDismissed(_that);case ComposerDraftFlushRequested() when draftFlushRequested != null:
return draftFlushRequested(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String text)?  textChanged,TResult Function( Message message)?  replySet,TResult Function()?  replyCleared,TResult Function( Message message)?  editStarted,TResult Function()?  editCancelled,TResult Function( Attachment attachment)?  attachmentAdded,TResult Function( String attachmentId)?  attachmentRemoved,TResult Function()?  sendPressed,TResult Function()?  failureDismissed,TResult Function()?  draftFlushRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ComposerStarted() when started != null:
return started();case ComposerTextChanged() when textChanged != null:
return textChanged(_that.text);case ComposerReplySet() when replySet != null:
return replySet(_that.message);case ComposerReplyCleared() when replyCleared != null:
return replyCleared();case ComposerEditStarted() when editStarted != null:
return editStarted(_that.message);case ComposerEditCancelled() when editCancelled != null:
return editCancelled();case ComposerAttachmentAdded() when attachmentAdded != null:
return attachmentAdded(_that.attachment);case ComposerAttachmentRemoved() when attachmentRemoved != null:
return attachmentRemoved(_that.attachmentId);case ComposerSendPressed() when sendPressed != null:
return sendPressed();case ComposerFailureDismissed() when failureDismissed != null:
return failureDismissed();case ComposerDraftFlushRequested() when draftFlushRequested != null:
return draftFlushRequested();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String text)  textChanged,required TResult Function( Message message)  replySet,required TResult Function()  replyCleared,required TResult Function( Message message)  editStarted,required TResult Function()  editCancelled,required TResult Function( Attachment attachment)  attachmentAdded,required TResult Function( String attachmentId)  attachmentRemoved,required TResult Function()  sendPressed,required TResult Function()  failureDismissed,required TResult Function()  draftFlushRequested,}) {final _that = this;
switch (_that) {
case ComposerStarted():
return started();case ComposerTextChanged():
return textChanged(_that.text);case ComposerReplySet():
return replySet(_that.message);case ComposerReplyCleared():
return replyCleared();case ComposerEditStarted():
return editStarted(_that.message);case ComposerEditCancelled():
return editCancelled();case ComposerAttachmentAdded():
return attachmentAdded(_that.attachment);case ComposerAttachmentRemoved():
return attachmentRemoved(_that.attachmentId);case ComposerSendPressed():
return sendPressed();case ComposerFailureDismissed():
return failureDismissed();case ComposerDraftFlushRequested():
return draftFlushRequested();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String text)?  textChanged,TResult? Function( Message message)?  replySet,TResult? Function()?  replyCleared,TResult? Function( Message message)?  editStarted,TResult? Function()?  editCancelled,TResult? Function( Attachment attachment)?  attachmentAdded,TResult? Function( String attachmentId)?  attachmentRemoved,TResult? Function()?  sendPressed,TResult? Function()?  failureDismissed,TResult? Function()?  draftFlushRequested,}) {final _that = this;
switch (_that) {
case ComposerStarted() when started != null:
return started();case ComposerTextChanged() when textChanged != null:
return textChanged(_that.text);case ComposerReplySet() when replySet != null:
return replySet(_that.message);case ComposerReplyCleared() when replyCleared != null:
return replyCleared();case ComposerEditStarted() when editStarted != null:
return editStarted(_that.message);case ComposerEditCancelled() when editCancelled != null:
return editCancelled();case ComposerAttachmentAdded() when attachmentAdded != null:
return attachmentAdded(_that.attachment);case ComposerAttachmentRemoved() when attachmentRemoved != null:
return attachmentRemoved(_that.attachmentId);case ComposerSendPressed() when sendPressed != null:
return sendPressed();case ComposerFailureDismissed() when failureDismissed != null:
return failureDismissed();case ComposerDraftFlushRequested() when draftFlushRequested != null:
return draftFlushRequested();case _:
  return null;

}
}

}

/// @nodoc


class ComposerStarted implements MessageComposerEvent {
  const ComposerStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent.started()';
}


}




/// @nodoc


class ComposerTextChanged implements MessageComposerEvent {
  const ComposerTextChanged(this.text);
  

 final  String text;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposerTextChangedCopyWith<ComposerTextChanged> get copyWith => _$ComposerTextChangedCopyWithImpl<ComposerTextChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerTextChanged&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'MessageComposerEvent.textChanged(text: $text)';
}


}

/// @nodoc
abstract mixin class $ComposerTextChangedCopyWith<$Res> implements $MessageComposerEventCopyWith<$Res> {
  factory $ComposerTextChangedCopyWith(ComposerTextChanged value, $Res Function(ComposerTextChanged) _then) = _$ComposerTextChangedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$ComposerTextChangedCopyWithImpl<$Res>
    implements $ComposerTextChangedCopyWith<$Res> {
  _$ComposerTextChangedCopyWithImpl(this._self, this._then);

  final ComposerTextChanged _self;
  final $Res Function(ComposerTextChanged) _then;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(ComposerTextChanged(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ComposerReplySet implements MessageComposerEvent {
  const ComposerReplySet(this.message);
  

 final  Message message;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposerReplySetCopyWith<ComposerReplySet> get copyWith => _$ComposerReplySetCopyWithImpl<ComposerReplySet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerReplySet&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MessageComposerEvent.replySet(message: $message)';
}


}

/// @nodoc
abstract mixin class $ComposerReplySetCopyWith<$Res> implements $MessageComposerEventCopyWith<$Res> {
  factory $ComposerReplySetCopyWith(ComposerReplySet value, $Res Function(ComposerReplySet) _then) = _$ComposerReplySetCopyWithImpl;
@useResult
$Res call({
 Message message
});




}
/// @nodoc
class _$ComposerReplySetCopyWithImpl<$Res>
    implements $ComposerReplySetCopyWith<$Res> {
  _$ComposerReplySetCopyWithImpl(this._self, this._then);

  final ComposerReplySet _self;
  final $Res Function(ComposerReplySet) _then;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ComposerReplySet(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as Message,
  ));
}


}

/// @nodoc


class ComposerReplyCleared implements MessageComposerEvent {
  const ComposerReplyCleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerReplyCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent.replyCleared()';
}


}




/// @nodoc


class ComposerEditStarted implements MessageComposerEvent {
  const ComposerEditStarted(this.message);
  

 final  Message message;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposerEditStartedCopyWith<ComposerEditStarted> get copyWith => _$ComposerEditStartedCopyWithImpl<ComposerEditStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerEditStarted&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MessageComposerEvent.editStarted(message: $message)';
}


}

/// @nodoc
abstract mixin class $ComposerEditStartedCopyWith<$Res> implements $MessageComposerEventCopyWith<$Res> {
  factory $ComposerEditStartedCopyWith(ComposerEditStarted value, $Res Function(ComposerEditStarted) _then) = _$ComposerEditStartedCopyWithImpl;
@useResult
$Res call({
 Message message
});




}
/// @nodoc
class _$ComposerEditStartedCopyWithImpl<$Res>
    implements $ComposerEditStartedCopyWith<$Res> {
  _$ComposerEditStartedCopyWithImpl(this._self, this._then);

  final ComposerEditStarted _self;
  final $Res Function(ComposerEditStarted) _then;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ComposerEditStarted(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as Message,
  ));
}


}

/// @nodoc


class ComposerEditCancelled implements MessageComposerEvent {
  const ComposerEditCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerEditCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent.editCancelled()';
}


}




/// @nodoc


class ComposerAttachmentAdded implements MessageComposerEvent {
  const ComposerAttachmentAdded(this.attachment);
  

 final  Attachment attachment;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposerAttachmentAddedCopyWith<ComposerAttachmentAdded> get copyWith => _$ComposerAttachmentAddedCopyWithImpl<ComposerAttachmentAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerAttachmentAdded&&(identical(other.attachment, attachment) || other.attachment == attachment));
}


@override
int get hashCode => Object.hash(runtimeType,attachment);

@override
String toString() {
  return 'MessageComposerEvent.attachmentAdded(attachment: $attachment)';
}


}

/// @nodoc
abstract mixin class $ComposerAttachmentAddedCopyWith<$Res> implements $MessageComposerEventCopyWith<$Res> {
  factory $ComposerAttachmentAddedCopyWith(ComposerAttachmentAdded value, $Res Function(ComposerAttachmentAdded) _then) = _$ComposerAttachmentAddedCopyWithImpl;
@useResult
$Res call({
 Attachment attachment
});




}
/// @nodoc
class _$ComposerAttachmentAddedCopyWithImpl<$Res>
    implements $ComposerAttachmentAddedCopyWith<$Res> {
  _$ComposerAttachmentAddedCopyWithImpl(this._self, this._then);

  final ComposerAttachmentAdded _self;
  final $Res Function(ComposerAttachmentAdded) _then;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attachment = null,}) {
  return _then(ComposerAttachmentAdded(
null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as Attachment,
  ));
}


}

/// @nodoc


class ComposerAttachmentRemoved implements MessageComposerEvent {
  const ComposerAttachmentRemoved(this.attachmentId);
  

 final  String attachmentId;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposerAttachmentRemovedCopyWith<ComposerAttachmentRemoved> get copyWith => _$ComposerAttachmentRemovedCopyWithImpl<ComposerAttachmentRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerAttachmentRemoved&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId));
}


@override
int get hashCode => Object.hash(runtimeType,attachmentId);

@override
String toString() {
  return 'MessageComposerEvent.attachmentRemoved(attachmentId: $attachmentId)';
}


}

/// @nodoc
abstract mixin class $ComposerAttachmentRemovedCopyWith<$Res> implements $MessageComposerEventCopyWith<$Res> {
  factory $ComposerAttachmentRemovedCopyWith(ComposerAttachmentRemoved value, $Res Function(ComposerAttachmentRemoved) _then) = _$ComposerAttachmentRemovedCopyWithImpl;
@useResult
$Res call({
 String attachmentId
});




}
/// @nodoc
class _$ComposerAttachmentRemovedCopyWithImpl<$Res>
    implements $ComposerAttachmentRemovedCopyWith<$Res> {
  _$ComposerAttachmentRemovedCopyWithImpl(this._self, this._then);

  final ComposerAttachmentRemoved _self;
  final $Res Function(ComposerAttachmentRemoved) _then;

/// Create a copy of MessageComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attachmentId = null,}) {
  return _then(ComposerAttachmentRemoved(
null == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ComposerSendPressed implements MessageComposerEvent {
  const ComposerSendPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerSendPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent.sendPressed()';
}


}




/// @nodoc


class ComposerFailureDismissed implements MessageComposerEvent {
  const ComposerFailureDismissed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerFailureDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent.failureDismissed()';
}


}




/// @nodoc


class ComposerDraftFlushRequested implements MessageComposerEvent {
  const ComposerDraftFlushRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposerDraftFlushRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageComposerEvent.draftFlushRequested()';
}


}




// dart format on
