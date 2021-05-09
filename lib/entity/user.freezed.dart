// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserPrivate _$UserPrivateFromJson(Map<String, dynamic> json) {
  return _UserPrivate.fromJson(json);
}

/// @nodoc
class _$UserPrivateTearOff {
  const _$UserPrivateTearOff();

  _UserPrivate call({String? fcmToken}) {
    return _UserPrivate(
      fcmToken: fcmToken,
    );
  }

  UserPrivate fromJson(Map<String, Object> json) {
    return UserPrivate.fromJson(json);
  }
}

/// @nodoc
const $UserPrivate = _$UserPrivateTearOff();

/// @nodoc
mixin _$UserPrivate {
  String? get fcmToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPrivateCopyWith<UserPrivate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPrivateCopyWith<$Res> {
  factory $UserPrivateCopyWith(
          UserPrivate value, $Res Function(UserPrivate) then) =
      _$UserPrivateCopyWithImpl<$Res>;
  $Res call({String? fcmToken});
}

/// @nodoc
class _$UserPrivateCopyWithImpl<$Res> implements $UserPrivateCopyWith<$Res> {
  _$UserPrivateCopyWithImpl(this._value, this._then);

  final UserPrivate _value;
  // ignore: unused_field
  final $Res Function(UserPrivate) _then;

  @override
  $Res call({
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$UserPrivateCopyWith<$Res>
    implements $UserPrivateCopyWith<$Res> {
  factory _$UserPrivateCopyWith(
          _UserPrivate value, $Res Function(_UserPrivate) then) =
      __$UserPrivateCopyWithImpl<$Res>;
  @override
  $Res call({String? fcmToken});
}

/// @nodoc
class __$UserPrivateCopyWithImpl<$Res> extends _$UserPrivateCopyWithImpl<$Res>
    implements _$UserPrivateCopyWith<$Res> {
  __$UserPrivateCopyWithImpl(
      _UserPrivate _value, $Res Function(_UserPrivate) _then)
      : super(_value, (v) => _then(v as _UserPrivate));

  @override
  _UserPrivate get _value => super._value as _UserPrivate;

  @override
  $Res call({
    Object? fcmToken = freezed,
  }) {
    return _then(_UserPrivate(
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserPrivate extends _UserPrivate {
  _$_UserPrivate({this.fcmToken}) : super._();

  factory _$_UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$_$_UserPrivateFromJson(json);

  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'UserPrivate(fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserPrivate &&
            (identical(other.fcmToken, fcmToken) ||
                const DeepCollectionEquality()
                    .equals(other.fcmToken, fcmToken)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(fcmToken);

  @JsonKey(ignore: true)
  @override
  _$UserPrivateCopyWith<_UserPrivate> get copyWith =>
      __$UserPrivateCopyWithImpl<_UserPrivate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserPrivateToJson(this);
  }
}

abstract class _UserPrivate extends UserPrivate {
  factory _UserPrivate({String? fcmToken}) = _$_UserPrivate;
  _UserPrivate._() : super._();

  factory _UserPrivate.fromJson(Map<String, dynamic> json) =
      _$_UserPrivate.fromJson;

  @override
  String? get fcmToken => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserPrivateCopyWith<_UserPrivate> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {@JsonKey(name: "settings") Setting? setting,
      bool migratedFlutter = false,
      bool isLinkedApple = false,
      bool isLinkedAndroid = false}) {
    return _User(
      setting: setting,
      migratedFlutter: migratedFlutter,
      isLinkedApple: isLinkedApple,
      isLinkedAndroid: isLinkedAndroid,
    );
  }

  User fromJson(Map<String, Object> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  @JsonKey(name: "settings")
  Setting? get setting => throw _privateConstructorUsedError;
  bool get migratedFlutter => throw _privateConstructorUsedError;
  bool get isLinkedApple => throw _privateConstructorUsedError;
  bool get isLinkedAndroid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "settings") Setting? setting,
      bool migratedFlutter,
      bool isLinkedApple,
      bool isLinkedAndroid});

  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? setting = freezed,
    Object? migratedFlutter = freezed,
    Object? isLinkedApple = freezed,
    Object? isLinkedAndroid = freezed,
  }) {
    return _then(_value.copyWith(
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      migratedFlutter: migratedFlutter == freezed
          ? _value.migratedFlutter
          : migratedFlutter // ignore: cast_nullable_to_non_nullable
              as bool,
      isLinkedApple: isLinkedApple == freezed
          ? _value.isLinkedApple
          : isLinkedApple // ignore: cast_nullable_to_non_nullable
              as bool,
      isLinkedAndroid: isLinkedAndroid == freezed
          ? _value.isLinkedAndroid
          : isLinkedAndroid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $SettingCopyWith<$Res>? get setting {
    if (_value.setting == null) {
      return null;
    }

    return $SettingCopyWith<$Res>(_value.setting!, (value) {
      return _then(_value.copyWith(setting: value));
    });
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "settings") Setting? setting,
      bool migratedFlutter,
      bool isLinkedApple,
      bool isLinkedAndroid});

  @override
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? setting = freezed,
    Object? migratedFlutter = freezed,
    Object? isLinkedApple = freezed,
    Object? isLinkedAndroid = freezed,
  }) {
    return _then(_User(
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      migratedFlutter: migratedFlutter == freezed
          ? _value.migratedFlutter
          : migratedFlutter // ignore: cast_nullable_to_non_nullable
              as bool,
      isLinkedApple: isLinkedApple == freezed
          ? _value.isLinkedApple
          : isLinkedApple // ignore: cast_nullable_to_non_nullable
              as bool,
      isLinkedAndroid: isLinkedAndroid == freezed
          ? _value.isLinkedAndroid
          : isLinkedAndroid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User extends _User {
  _$_User(
      {@JsonKey(name: "settings") this.setting,
      this.migratedFlutter = false,
      this.isLinkedApple = false,
      this.isLinkedAndroid = false})
      : super._();

  factory _$_User.fromJson(Map<String, dynamic> json) =>
      _$_$_UserFromJson(json);

  @override
  @JsonKey(name: "settings")
  final Setting? setting;
  @JsonKey(defaultValue: false)
  @override
  final bool migratedFlutter;
  @JsonKey(defaultValue: false)
  @override
  final bool isLinkedApple;
  @JsonKey(defaultValue: false)
  @override
  final bool isLinkedAndroid;

  @override
  String toString() {
    return 'User(setting: $setting, migratedFlutter: $migratedFlutter, isLinkedApple: $isLinkedApple, isLinkedAndroid: $isLinkedAndroid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.migratedFlutter, migratedFlutter) ||
                const DeepCollectionEquality()
                    .equals(other.migratedFlutter, migratedFlutter)) &&
            (identical(other.isLinkedApple, isLinkedApple) ||
                const DeepCollectionEquality()
                    .equals(other.isLinkedApple, isLinkedApple)) &&
            (identical(other.isLinkedAndroid, isLinkedAndroid) ||
                const DeepCollectionEquality()
                    .equals(other.isLinkedAndroid, isLinkedAndroid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(migratedFlutter) ^
      const DeepCollectionEquality().hash(isLinkedApple) ^
      const DeepCollectionEquality().hash(isLinkedAndroid);

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserToJson(this);
  }
}

abstract class _User extends User {
  factory _User(
      {@JsonKey(name: "settings") Setting? setting,
      bool migratedFlutter,
      bool isLinkedApple,
      bool isLinkedAndroid}) = _$_User;
  _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  @JsonKey(name: "settings")
  Setting? get setting => throw _privateConstructorUsedError;
  @override
  bool get migratedFlutter => throw _privateConstructorUsedError;
  @override
  bool get isLinkedApple => throw _privateConstructorUsedError;
  @override
  bool get isLinkedAndroid => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}
