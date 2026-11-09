// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListState()';
}


}

/// @nodoc
class $MessageListStateCopyWith<$Res>  {
$MessageListStateCopyWith(MessageListState _, $Res Function(MessageListState) __);
}


/// Adds pattern-matching-related methods to [MessageListState].
extension MessageListStatePatterns on MessageListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MessageListInitial value)?  initial,TResult Function( MessageListLoading value)?  loading,TResult Function( MessageListLoaded value)?  loaded,TResult Function( MessageListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MessageListInitial() when initial != null:
return initial(_that);case MessageListLoading() when loading != null:
return loading(_that);case MessageListLoaded() when loaded != null:
return loaded(_that);case MessageListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MessageListInitial value)  initial,required TResult Function( MessageListLoading value)  loading,required TResult Function( MessageListLoaded value)  loaded,required TResult Function( MessageListError value)  error,}){
final _that = this;
switch (_that) {
case MessageListInitial():
return initial(_that);case MessageListLoading():
return loading(_that);case MessageListLoaded():
return loaded(_that);case MessageListError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MessageListInitial value)?  initial,TResult? Function( MessageListLoading value)?  loading,TResult? Function( MessageListLoaded value)?  loaded,TResult? Function( MessageListError value)?  error,}){
final _that = this;
switch (_that) {
case MessageListInitial() when initial != null:
return initial(_that);case MessageListLoading() when loading != null:
return loading(_that);case MessageListLoaded() when loaded != null:
return loaded(_that);case MessageListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Message> messages,  bool hasMore,  bool isLoadingMore,  Failure? transientFailure)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MessageListInitial() when initial != null:
return initial();case MessageListLoading() when loading != null:
return loading();case MessageListLoaded() when loaded != null:
return loaded(_that.messages,_that.hasMore,_that.isLoadingMore,_that.transientFailure);case MessageListError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Message> messages,  bool hasMore,  bool isLoadingMore,  Failure? transientFailure)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case MessageListInitial():
return initial();case MessageListLoading():
return loading();case MessageListLoaded():
return loaded(_that.messages,_that.hasMore,_that.isLoadingMore,_that.transientFailure);case MessageListError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Message> messages,  bool hasMore,  bool isLoadingMore,  Failure? transientFailure)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case MessageListInitial() when initial != null:
return initial();case MessageListLoading() when loading != null:
return loading();case MessageListLoaded() when loaded != null:
return loaded(_that.messages,_that.hasMore,_that.isLoadingMore,_that.transientFailure);case MessageListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MessageListInitial implements MessageListState {
  const MessageListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListState.initial()';
}


}




/// @nodoc


class MessageListLoading implements MessageListState {
  const MessageListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageListState.loading()';
}


}




/// @nodoc


class MessageListLoaded implements MessageListState {
  const MessageListLoaded({required final  List<Message> messages, this.hasMore = true, this.isLoadingMore = false, this.transientFailure}): _messages = messages;
  

 final  List<Message> _messages;
 List<Message> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  bool isLoadingMore;
 final  Failure? transientFailure;

/// Create a copy of MessageListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListLoadedCopyWith<MessageListLoaded> get copyWith => _$MessageListLoadedCopyWithImpl<MessageListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListLoaded&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),hasMore,isLoadingMore,transientFailure);

@override
String toString() {
  return 'MessageListState.loaded(messages: $messages, hasMore: $hasMore, isLoadingMore: $isLoadingMore, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class $MessageListLoadedCopyWith<$Res> implements $MessageListStateCopyWith<$Res> {
  factory $MessageListLoadedCopyWith(MessageListLoaded value, $Res Function(MessageListLoaded) _then) = _$MessageListLoadedCopyWithImpl;
@useResult
$Res call({
 List<Message> messages, bool hasMore, bool isLoadingMore, Failure? transientFailure
});




}
/// @nodoc
class _$MessageListLoadedCopyWithImpl<$Res>
    implements $MessageListLoadedCopyWith<$Res> {
  _$MessageListLoadedCopyWithImpl(this._self, this._then);

  final MessageListLoaded _self;
  final $Res Function(MessageListLoaded) _then;

/// Create a copy of MessageListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? hasMore = null,Object? isLoadingMore = null,Object? transientFailure = freezed,}) {
  return _then(MessageListLoaded(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc


class MessageListError implements MessageListState {
  const MessageListError(this.failure);
  

 final  Failure failure;

/// Create a copy of MessageListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageListErrorCopyWith<MessageListError> get copyWith => _$MessageListErrorCopyWithImpl<MessageListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MessageListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MessageListErrorCopyWith<$Res> implements $MessageListStateCopyWith<$Res> {
  factory $MessageListErrorCopyWith(MessageListError value, $Res Function(MessageListError) _then) = _$MessageListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MessageListErrorCopyWithImpl<$Res>
    implements $MessageListErrorCopyWith<$Res> {
  _$MessageListErrorCopyWithImpl(this._self, this._then);

  final MessageListError _self;
  final $Res Function(MessageListError) _then;

/// Create a copy of MessageListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MessageListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
