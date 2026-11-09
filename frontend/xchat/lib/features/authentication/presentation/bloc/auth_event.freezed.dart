// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthStarted value)?  started,TResult Function( AuthOtpRequested value)?  otpRequested,TResult Function( AuthOtpSubmitted value)?  otpSubmitted,TResult Function( AuthBackToPhoneRequested value)?  backToPhoneRequested,TResult Function( AuthSignOutRequested value)?  signOutRequested,TResult Function( AuthDeleteAccountRequested value)?  deleteAccountRequested,TResult Function( AuthFailureDismissed value)?  failureDismissed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthOtpRequested() when otpRequested != null:
return otpRequested(_that);case AuthOtpSubmitted() when otpSubmitted != null:
return otpSubmitted(_that);case AuthBackToPhoneRequested() when backToPhoneRequested != null:
return backToPhoneRequested(_that);case AuthSignOutRequested() when signOutRequested != null:
return signOutRequested(_that);case AuthDeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested(_that);case AuthFailureDismissed() when failureDismissed != null:
return failureDismissed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthStarted value)  started,required TResult Function( AuthOtpRequested value)  otpRequested,required TResult Function( AuthOtpSubmitted value)  otpSubmitted,required TResult Function( AuthBackToPhoneRequested value)  backToPhoneRequested,required TResult Function( AuthSignOutRequested value)  signOutRequested,required TResult Function( AuthDeleteAccountRequested value)  deleteAccountRequested,required TResult Function( AuthFailureDismissed value)  failureDismissed,}){
final _that = this;
switch (_that) {
case AuthStarted():
return started(_that);case AuthOtpRequested():
return otpRequested(_that);case AuthOtpSubmitted():
return otpSubmitted(_that);case AuthBackToPhoneRequested():
return backToPhoneRequested(_that);case AuthSignOutRequested():
return signOutRequested(_that);case AuthDeleteAccountRequested():
return deleteAccountRequested(_that);case AuthFailureDismissed():
return failureDismissed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthStarted value)?  started,TResult? Function( AuthOtpRequested value)?  otpRequested,TResult? Function( AuthOtpSubmitted value)?  otpSubmitted,TResult? Function( AuthBackToPhoneRequested value)?  backToPhoneRequested,TResult? Function( AuthSignOutRequested value)?  signOutRequested,TResult? Function( AuthDeleteAccountRequested value)?  deleteAccountRequested,TResult? Function( AuthFailureDismissed value)?  failureDismissed,}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthOtpRequested() when otpRequested != null:
return otpRequested(_that);case AuthOtpSubmitted() when otpSubmitted != null:
return otpSubmitted(_that);case AuthBackToPhoneRequested() when backToPhoneRequested != null:
return backToPhoneRequested(_that);case AuthSignOutRequested() when signOutRequested != null:
return signOutRequested(_that);case AuthDeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested(_that);case AuthFailureDismissed() when failureDismissed != null:
return failureDismissed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String phone)?  otpRequested,TResult Function( String code)?  otpSubmitted,TResult Function()?  backToPhoneRequested,TResult Function()?  signOutRequested,TResult Function()?  deleteAccountRequested,TResult Function()?  failureDismissed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthOtpRequested() when otpRequested != null:
return otpRequested(_that.phone);case AuthOtpSubmitted() when otpSubmitted != null:
return otpSubmitted(_that.code);case AuthBackToPhoneRequested() when backToPhoneRequested != null:
return backToPhoneRequested();case AuthSignOutRequested() when signOutRequested != null:
return signOutRequested();case AuthDeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested();case AuthFailureDismissed() when failureDismissed != null:
return failureDismissed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String phone)  otpRequested,required TResult Function( String code)  otpSubmitted,required TResult Function()  backToPhoneRequested,required TResult Function()  signOutRequested,required TResult Function()  deleteAccountRequested,required TResult Function()  failureDismissed,}) {final _that = this;
switch (_that) {
case AuthStarted():
return started();case AuthOtpRequested():
return otpRequested(_that.phone);case AuthOtpSubmitted():
return otpSubmitted(_that.code);case AuthBackToPhoneRequested():
return backToPhoneRequested();case AuthSignOutRequested():
return signOutRequested();case AuthDeleteAccountRequested():
return deleteAccountRequested();case AuthFailureDismissed():
return failureDismissed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String phone)?  otpRequested,TResult? Function( String code)?  otpSubmitted,TResult? Function()?  backToPhoneRequested,TResult? Function()?  signOutRequested,TResult? Function()?  deleteAccountRequested,TResult? Function()?  failureDismissed,}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthOtpRequested() when otpRequested != null:
return otpRequested(_that.phone);case AuthOtpSubmitted() when otpSubmitted != null:
return otpSubmitted(_that.code);case AuthBackToPhoneRequested() when backToPhoneRequested != null:
return backToPhoneRequested();case AuthSignOutRequested() when signOutRequested != null:
return signOutRequested();case AuthDeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested();case AuthFailureDismissed() when failureDismissed != null:
return failureDismissed();case _:
  return null;

}
}

}

/// @nodoc


class AuthStarted implements AuthEvent {
  const AuthStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.started()';
}


}




/// @nodoc


class AuthOtpRequested implements AuthEvent {
  const AuthOtpRequested(this.phone);
  

 final  String phone;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOtpRequestedCopyWith<AuthOtpRequested> get copyWith => _$AuthOtpRequestedCopyWithImpl<AuthOtpRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOtpRequested&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'AuthEvent.otpRequested(phone: $phone)';
}


}

/// @nodoc
abstract mixin class $AuthOtpRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthOtpRequestedCopyWith(AuthOtpRequested value, $Res Function(AuthOtpRequested) _then) = _$AuthOtpRequestedCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class _$AuthOtpRequestedCopyWithImpl<$Res>
    implements $AuthOtpRequestedCopyWith<$Res> {
  _$AuthOtpRequestedCopyWithImpl(this._self, this._then);

  final AuthOtpRequested _self;
  final $Res Function(AuthOtpRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(AuthOtpRequested(
null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthOtpSubmitted implements AuthEvent {
  const AuthOtpSubmitted(this.code);
  

 final  String code;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOtpSubmittedCopyWith<AuthOtpSubmitted> get copyWith => _$AuthOtpSubmittedCopyWithImpl<AuthOtpSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOtpSubmitted&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'AuthEvent.otpSubmitted(code: $code)';
}


}

/// @nodoc
abstract mixin class $AuthOtpSubmittedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthOtpSubmittedCopyWith(AuthOtpSubmitted value, $Res Function(AuthOtpSubmitted) _then) = _$AuthOtpSubmittedCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$AuthOtpSubmittedCopyWithImpl<$Res>
    implements $AuthOtpSubmittedCopyWith<$Res> {
  _$AuthOtpSubmittedCopyWithImpl(this._self, this._then);

  final AuthOtpSubmitted _self;
  final $Res Function(AuthOtpSubmitted) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(AuthOtpSubmitted(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthBackToPhoneRequested implements AuthEvent {
  const AuthBackToPhoneRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthBackToPhoneRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.backToPhoneRequested()';
}


}




/// @nodoc


class AuthSignOutRequested implements AuthEvent {
  const AuthSignOutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSignOutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signOutRequested()';
}


}




/// @nodoc


class AuthDeleteAccountRequested implements AuthEvent {
  const AuthDeleteAccountRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthDeleteAccountRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.deleteAccountRequested()';
}


}




/// @nodoc


class AuthFailureDismissed implements AuthEvent {
  const AuthFailureDismissed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailureDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.failureDismissed()';
}


}




// dart format on
