// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_composer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageComposerState {

 String get text; Message? get replyTo; Message? get editing;/// Text that was in the composer before edit mode started (restored on cancel).
 String? get textBeforeEdit; List<Attachment> get attachments; bool get isSending; Failure? get failure;
/// Create a copy of MessageComposerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageComposerStateCopyWith<MessageComposerState> get copyWith => _$MessageComposerStateCopyWithImpl<MessageComposerState>(this as MessageComposerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageComposerState&&(identical(other.text, text) || other.text == text)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.textBeforeEdit, textBeforeEdit) || other.textBeforeEdit == textBeforeEdit)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,text,replyTo,editing,textBeforeEdit,const DeepCollectionEquality().hash(attachments),isSending,failure);

@override
String toString() {
  return 'MessageComposerState(text: $text, replyTo: $replyTo, editing: $editing, textBeforeEdit: $textBeforeEdit, attachments: $attachments, isSending: $isSending, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MessageComposerStateCopyWith<$Res>  {
  factory $MessageComposerStateCopyWith(MessageComposerState value, $Res Function(MessageComposerState) _then) = _$MessageComposerStateCopyWithImpl;
@useResult
$Res call({
 String text, Message? replyTo, Message? editing, String? textBeforeEdit, List<Attachment> attachments, bool isSending, Failure? failure
});




}
/// @nodoc
class _$MessageComposerStateCopyWithImpl<$Res>
    implements $MessageComposerStateCopyWith<$Res> {
  _$MessageComposerStateCopyWithImpl(this._self, this._then);

  final MessageComposerState _self;
  final $Res Function(MessageComposerState) _then;

/// Create a copy of MessageComposerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? replyTo = freezed,Object? editing = freezed,Object? textBeforeEdit = freezed,Object? attachments = null,Object? isSending = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as Message?,editing: freezed == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as Message?,textBeforeEdit: freezed == textBeforeEdit ? _self.textBeforeEdit : textBeforeEdit // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageComposerState].
extension MessageComposerStatePatterns on MessageComposerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageComposerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageComposerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageComposerState value)  $default,){
final _that = this;
switch (_that) {
case _MessageComposerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageComposerState value)?  $default,){
final _that = this;
switch (_that) {
case _MessageComposerState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  Message? replyTo,  Message? editing,  String? textBeforeEdit,  List<Attachment> attachments,  bool isSending,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageComposerState() when $default != null:
return $default(_that.text,_that.replyTo,_that.editing,_that.textBeforeEdit,_that.attachments,_that.isSending,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  Message? replyTo,  Message? editing,  String? textBeforeEdit,  List<Attachment> attachments,  bool isSending,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MessageComposerState():
return $default(_that.text,_that.replyTo,_that.editing,_that.textBeforeEdit,_that.attachments,_that.isSending,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  Message? replyTo,  Message? editing,  String? textBeforeEdit,  List<Attachment> attachments,  bool isSending,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MessageComposerState() when $default != null:
return $default(_that.text,_that.replyTo,_that.editing,_that.textBeforeEdit,_that.attachments,_that.isSending,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MessageComposerState extends MessageComposerState {
  const _MessageComposerState({this.text = '', this.replyTo, this.editing, this.textBeforeEdit, final  List<Attachment> attachments = const <Attachment>[], this.isSending = false, this.failure}): _attachments = attachments,super._();
  

@override@JsonKey() final  String text;
@override final  Message? replyTo;
@override final  Message? editing;
/// Text that was in the composer before edit mode started (restored on cancel).
@override final  String? textBeforeEdit;
 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override@JsonKey() final  bool isSending;
@override final  Failure? failure;

/// Create a copy of MessageComposerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageComposerStateCopyWith<_MessageComposerState> get copyWith => __$MessageComposerStateCopyWithImpl<_MessageComposerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageComposerState&&(identical(other.text, text) || other.text == text)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.textBeforeEdit, textBeforeEdit) || other.textBeforeEdit == textBeforeEdit)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,text,replyTo,editing,textBeforeEdit,const DeepCollectionEquality().hash(_attachments),isSending,failure);

@override
String toString() {
  return 'MessageComposerState(text: $text, replyTo: $replyTo, editing: $editing, textBeforeEdit: $textBeforeEdit, attachments: $attachments, isSending: $isSending, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MessageComposerStateCopyWith<$Res> implements $MessageComposerStateCopyWith<$Res> {
  factory _$MessageComposerStateCopyWith(_MessageComposerState value, $Res Function(_MessageComposerState) _then) = __$MessageComposerStateCopyWithImpl;
@override @useResult
$Res call({
 String text, Message? replyTo, Message? editing, String? textBeforeEdit, List<Attachment> attachments, bool isSending, Failure? failure
});




}
/// @nodoc
class __$MessageComposerStateCopyWithImpl<$Res>
    implements _$MessageComposerStateCopyWith<$Res> {
  __$MessageComposerStateCopyWithImpl(this._self, this._then);

  final _MessageComposerState _self;
  final $Res Function(_MessageComposerState) _then;

/// Create a copy of MessageComposerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? replyTo = freezed,Object? editing = freezed,Object? textBeforeEdit = freezed,Object? attachments = null,Object? isSending = null,Object? failure = freezed,}) {
  return _then(_MessageComposerState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as Message?,editing: freezed == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as Message?,textBeforeEdit: freezed == textBeforeEdit ? _self.textBeforeEdit : textBeforeEdit // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
