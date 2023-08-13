import 'package:flutter/foundation.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'typed_shared_preferences.g.dart';

@immutable
class SharedPreferencesState<T> {
  final String key;
  final T? value;

  const SharedPreferencesState(this.key, this.value);
}

@riverpod
class BoolSharedPreferences extends _$BoolSharedPreferences {
  @override
  SharedPreferencesState<bool?> build(String key) => SharedPreferencesState(key, ref.read(sharedPreferencesProvider).getBool(key));

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(state.key, value);
    state = SharedPreferencesState(key, value);
  }
}

// @riverpod
// class IntSharedPreferences extends _$IntSharedPreferences {
//   final String key;
// 
//   IntSharedPreferences(this.key);
// 
//   @override
//   int? build() => ref.read(sharedPreferencesProvider).getInt(key);
// 
//   Future<void> set(int value) async {
//     await ref.read(sharedPreferencesProvider).setInt(key, value);
//     state = value;
//   }
// }
// 
// @riverpod
// class StringSharedPreferences extends _$StringSharedPreferences {
//   final String key;
// 
//   StringSharedPreferences(this.key);
// 
//   @override
//   String? build() => ref.read(sharedPreferencesProvider).getString(key);
// 
//   Future<void> set(String value) async {
//     await ref.read(sharedPreferencesProvider).setString(key, value);
//     state = value;
//   }
// }
// 