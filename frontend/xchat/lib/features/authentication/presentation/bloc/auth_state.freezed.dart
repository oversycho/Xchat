// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthUnknown value)?  unknown,TResult Function( AuthUnauthenticated value)?  unauthenticated,TResult Function( AuthAuthenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthUnknown value)  unknown,required TResult Function( AuthUnauthenticated value)  unauthenticated,required TResult Function( AuthAuthenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case AuthUnknown():
return unknown(_that);case AuthUnauthenticated():
return unauthenticated(_that);case AuthAuthenticated():
return authenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthUnknown value)?  unknown,TResult? Function( AuthUnauthenticated value)?  unauthenticated,TResult? Function( AuthAuthenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( AuthStep step,  String? phone,  bool isBusy,  Failure? failure)?  unauthenticated,TResult Function( AuthUser user,  bool isBusy,  Failure? failure)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown();case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.step,_that.phone,_that.isBusy,_that.failure);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user,_that.isBusy,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( AuthStep step,  String? phone,  bool isBusy,  Failure? failure)  unauthenticated,required TResult Function( AuthUser user,  bool isBusy,  Failure? failure)  authenticated,}) {final _that = this;
switch (_that) {
case AuthUnknown():
return unknown();case AuthUnauthenticated():
return unauthenticated(_that.step,_that.phone,_that.isBusy,_that.failure);case AuthAuthenticated():
return authenticated(_that.user,_that.isBusy,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( AuthStep step,  String? phone,  bool isBusy,  Failure? failure)?  unauthenticated,TResult? Function( AuthUser user,  bool isBusy,  Failure? failure)?  authenticated,}) {final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown();case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.step,_that.phone,_that.isBusy,_that.failure);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user,_that.isBusy,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AuthUnknown implements AuthState {
  const AuthUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unknown()';
}


}




/// @nodoc


class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated({this.step = AuthStep.enterPhone, this.phone, this.isBusy = false, this.failure});
  

@JsonKey() final  AuthStep step;
 final  String? phone;
@JsonKey() final  bool isBusy;
 final  Failure? failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUnauthenticatedCopyWith<AuthUnauthenticated> get copyWith => _$AuthUnauthenticatedCopyWithImpl<AuthUnauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnauthenticated&&(identical(other.step, step) || other.step == step)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,step,phone,isBusy,failure);

@override
String toString() {
  return 'AuthState.unauthenticated(step: $step, phone: $phone, isBusy: $isBusy, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AuthUnauthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthUnauthenticatedCopyWith(AuthUnauthenticated value, $Res Function(AuthUnauthenticated) _then) = _$AuthUnauthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthStep step, String? phone, bool isBusy, Failure? failure
});




}
/// @nodoc
class _$AuthUnauthenticatedCopyWithImpl<$Res>
    implements $AuthUnauthenticatedCopyWith<$Res> {
  _$AuthUnauthenticatedCopyWithImpl(this._self, this._then);

  final AuthUnauthenticated _self;
  final $Res Function(AuthUnauthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? step = null,Object? phone = freezed,Object? isBusy = null,Object? failure = freezed,}) {
  return _then(AuthUnauthenticated(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as AuthStep,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc


class AuthAuthenticated implements AuthState {
  const AuthAuthenticated({required this.user, this.isBusy = false, this.failure});
  

 final  AuthUser user;
@JsonKey() final  bool isBusy;
 final  Failure? failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith => _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAuthenticated&&(identical(other.user, user) || other.user == user)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,user,isBusy,failure);

@override
String toString() {
  return 'AuthState.authenticated(user: $user, isBusy: $isBusy, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) = _$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthUser user, bool isBusy, Failure? failure
});




}
/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? isBusy = null,Object? failure = freezed,}) {
  return _then(AuthAuthenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
