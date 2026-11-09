// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_list_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListEvent()';
}


}

/// @nodoc
class $MessageListEventCopyWith<$Res>  {
$MessageListEventCopyWith(MessageListEvent _, $Res Function(MessageListEvent) __);
}


/// Adds pattern-matching-related methods to [MessageListEvent].
extension MessageListEventPatterns on MessageListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MessageListStarted value)?  started,TResult Function( MessageListOlderRequested value)?  olderRequested,TResult Function( MessageListDeleteRequested value)?  deleteRequested,TResult Function( MessageListReactionToggled value)?  reactionToggled,TResult Function( MessageListRetryRequested value)?  retryRequested,TResult Function( MessageListFailureDismissed value)?  failureDismissed,TResult Function( MessageListSyncFailed value)?  syncFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MessageListStarted() when started != null:
return started(_that);case MessageListOlderRequested() when olderRequested != null:
return olderRequested(_that);case MessageListDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case MessageListReactionToggled() when reactionToggled != null:
return reactionToggled(_that);case MessageListRetryRequested() when retryRequested != null:
return retryRequested(_that);case MessageListFailureDismissed() when failureDismissed != null:
return failureDismissed(_that);case MessageListSyncFailed() when syncFailed != null:
return syncFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MessageListStarted value)  started,required TResult Function( MessageListOlderRequested value)  olderRequested,required TResult Function( MessageListDeleteRequested value)  deleteRequested,required TResult Function( MessageListReactionToggled value)  reactionToggled,required TResult Function( MessageListRetryRequested value)  retryRequested,required TResult Function( MessageListFailureDismissed value)  failureDismissed,required TResult Function( MessageListSyncFailed value)  syncFailed,}){
final _that = this;
switch (_that) {
case MessageListStarted():
return started(_that);case MessageListOlderRequested():
return olderRequested(_that);case MessageListDeleteRequested():
return deleteRequested(_that);case MessageListReactionToggled():
return reactionToggled(_that);case MessageListRetryRequested():
return retryRequested(_that);case MessageListFailureDismissed():
return failureDismissed(_that);case MessageListSyncFailed():
return syncFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MessageListStarted value)?  started,TResult? Function( MessageListOlderRequested value)?  olderRequested,TResult? Function( MessageListDeleteRequested value)?  deleteRequested,TResult? Function( MessageListReactionToggled value)?  reactionToggled,TResult? Function( MessageListRetryRequested value)?  retryRequested,TResult? Function( MessageListFailureDismissed value)?  failureDismissed,TResult? Function( MessageListSyncFailed value)?  syncFailed,}){
final _that = this;
switch (_that) {
case MessageListStarted() when started != null:
return started(_that);case MessageListOlderRequested() when olderRequested != null:
return olderRequested(_that);case MessageListDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case MessageListReactionToggled() when reactionToggled != null:
return reactionToggled(_that);case MessageListRetryRequested() when retryRequested != null:
return retryRequested(_that);case MessageListFailureDismissed() when failureDismissed != null:
return failureDismissed(_that);case MessageListSyncFailed() when syncFailed != null:
return syncFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  olderRequested,TResult Function( String messageId)?  deleteRequested,TResult Function( String messageId,  String emoji)?  reactionToggled,TResult Function( String messageId)?  retryRequested,TResult Function()?  failureDismissed,TResult Function( Failure failure)?  syncFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MessageListStarted() when started != null:
return started();case MessageListOlderRequested() when olderRequested != null:
return olderRequested();case MessageListDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.messageId);case MessageListReactionToggled() when reactionToggled != null:
return reactionToggled(_that.messageId,_that.emoji);case MessageListRetryRequested() when retryRequested != null:
return retryRequested(_that.messageId);case MessageListFailureDismissed() when failureDismissed != null:
return failureDismissed();case MessageListSyncFailed() when syncFailed != null:
return syncFailed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  olderRequested,required TResult Function( String messageId)  deleteRequested,required TResult Function( String messageId,  String emoji)  reactionToggled,required TResult Function( String messageId)  retryRequested,required TResult Function()  failureDismissed,required TResult Function( Failure failure)  syncFailed,}) {final _that = this;
switch (_that) {
case MessageListStarted():
return started();case MessageListOlderRequested():
return olderRequested();case MessageListDeleteRequested():
return deleteRequested(_that.messageId);case MessageListReactionToggled():
return reactionToggled(_that.messageId,_that.emoji);case MessageListRetryRequested():
return retryRequested(_that.messageId);case MessageListFailureDismissed():
return failureDismissed();case MessageListSyncFailed():
return syncFailed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  olderRequested,TResult? Function( String messageId)?  deleteRequested,TResult? Function( String messageId,  String emoji)?  reactionToggled,TResult? Function( String messageId)?  retryRequested,TResult? Function()?  failureDismissed,TResult? Function( Failure failure)?  syncFailed,}) {final _that = this;
switch (_that) {
case MessageListStarted() when started != null:
return started();case MessageListOlderRequested() when olderRequested != null:
return olderRequested();case MessageListDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.messageId);case MessageListReactionToggled() when reactionToggled != null:
return reactionToggled(_that.messageId,_that.emoji);case MessageListRetryRequested() when retryRequested != null:
return retryRequested(_that.messageId);case MessageListFailureDismissed() when failureDismissed != null:
return failureDismissed();case MessageListSyncFailed() when syncFailed != null:
return syncFailed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MessageListStarted implements MessageListEvent {
  const MessageListStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListEvent.started()';
}


}




/// @nodoc


class MessageListOlderRequested implements MessageListEvent {
  const MessageListOlderRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListOlderRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListEvent.olderRequested()';
}


}




/// @nodoc


class MessageListDeleteRequested implements MessageListEvent {
  const MessageListDeleteRequested(this.messageId);
  

 final  String messageId;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListDeleteRequestedCopyWith<MessageListDeleteRequested> get copyWith => _$MessageListDeleteRequestedCopyWithImpl<MessageListDeleteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListDeleteRequested&&(identical(other.messageId, messageId) || other.messageId == messageId));
}


@override
int get hashCode => Object.hash(runtimeType,messageId);

@override
String toString() {
  return 'MessageListEvent.deleteRequested(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class $MessageListDeleteRequestedCopyWith<$Res> implements $MessageListEventCopyWith<$Res> {
  factory $MessageListDeleteRequestedCopyWith(MessageListDeleteRequested value, $Res Function(MessageListDeleteRequested) _then) = _$MessageListDeleteRequestedCopyWithImpl;
@useResult
$Res call({
 String messageId
});




}
/// @nodoc
class _$MessageListDeleteRequestedCopyWithImpl<$Res>
    implements $MessageListDeleteRequestedCopyWith<$Res> {
  _$MessageListDeleteRequestedCopyWithImpl(this._self, this._then);

  final MessageListDeleteRequested _self;
  final $Res Function(MessageListDeleteRequested) _then;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageId = null,}) {
  return _then(MessageListDeleteRequested(
null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MessageListReactionToggled implements MessageListEvent {
  const MessageListReactionToggled({required this.messageId, required this.emoji});
  

 final  String messageId;
 final  String emoji;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListReactionToggledCopyWith<MessageListReactionToggled> get copyWith => _$MessageListReactionToggledCopyWithImpl<MessageListReactionToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListReactionToggled&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}


@override
int get hashCode => Object.hash(runtimeType,messageId,emoji);

@override
String toString() {
  return 'MessageListEvent.reactionToggled(messageId: $messageId, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $MessageListReactionToggledCopyWith<$Res> implements $MessageListEventCopyWith<$Res> {
  factory $MessageListReactionToggledCopyWith(MessageListReactionToggled value, $Res Function(MessageListReactionToggled) _then) = _$MessageListReactionToggledCopyWithImpl;
@useResult
$Res call({
 String messageId, String emoji
});




}
/// @nodoc
class _$MessageListReactionToggledCopyWithImpl<$Res>
    implements $MessageListReactionToggledCopyWith<$Res> {
  _$MessageListReactionToggledCopyWithImpl(this._self, this._then);

  final MessageListReactionToggled _self;
  final $Res Function(MessageListReactionToggled) _then;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? emoji = null,}) {
  return _then(MessageListReactionToggled(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MessageListRetryRequested implements MessageListEvent {
  const MessageListRetryRequested(this.messageId);
  

 final  String messageId;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListRetryRequestedCopyWith<MessageListRetryRequested> get copyWith => _$MessageListRetryRequestedCopyWithImpl<MessageListRetryRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListRetryRequested&&(identical(other.messageId, messageId) || other.messageId == messageId));
}


@override
int get hashCode => Object.hash(runtimeType,messageId);

@override
String toString() {
  return 'MessageListEvent.retryRequested(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class $MessageListRetryRequestedCopyWith<$Res> implements $MessageListEventCopyWith<$Res> {
  factory $MessageListRetryRequestedCopyWith(MessageListRetryRequested value, $Res Function(MessageListRetryRequested) _then) = _$MessageListRetryRequestedCopyWithImpl;
@useResult
$Res call({
 String messageId
});




}
/// @nodoc
class _$MessageListRetryRequestedCopyWithImpl<$Res>
    implements $MessageListRetryRequestedCopyWith<$Res> {
  _$MessageListRetryRequestedCopyWithImpl(this._self, this._then);

  final MessageListRetryRequested _self;
  final $Res Function(MessageListRetryRequested) _then;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageId = null,}) {
  return _then(MessageListRetryRequested(
null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MessageListFailureDismissed implements MessageListEvent {
  const MessageListFailureDismissed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListFailureDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListEvent.failureDismissed()';
}


}




/// @nodoc


class MessageListSyncFailed implements MessageListEvent {
  const MessageListSyncFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListSyncFailedCopyWith<MessageListSyncFailed> get copyWith => _$MessageListSyncFailedCopyWithImpl<MessageListSyncFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListSyncFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MessageListEvent.syncFailed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MessageListSyncFailedCopyWith<$Res> implements $MessageListEventCopyWith<$Res> {
  factory $MessageListSyncFailedCopyWith(MessageListSyncFailed value, $Res Function(MessageListSyncFailed) _then) = _$MessageListSyncFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MessageListSyncFailedCopyWithImpl<$Res>
    implements $MessageListSyncFailedCopyWith<$Res> {
  _$MessageListSyncFailedCopyWithImpl(this._self, this._then);

  final MessageListSyncFailed _self;
  final $Res Function(MessageListSyncFailed) _then;

/// Create a copy of MessageListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MessageListSyncFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
