import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/auth/link_value_container.dart';
import 'package:pilll/provider/auth.dart';

enum SignInWithAppleState { determined, cancel }

Future<LinkValueContainer?> linkWithApple(User user) async {
  try {
    final provider = AppleAuthProvider()..addScope('email');
    final linkedCredential = await user.linkWithProvider(provider);
    return Future.value(LinkValueContainer(linkedCredential, linkedCredential.user?.email));
  } on FirebaseAuthException catch (e) {
    rethrow;
  }
}

Future<UserCredential?> signInWithApple() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw const FormatException("Anonymous User not found");
  }
  final provider = AppleAuthProvider()..addScope('email');
  return await FirebaseAuth.instance.signInWithProvider(provider);
}

final isAppleLinkedProvider = Provider((ref) {
  final user = ref.watch(firebaseUserStateProvider);
  final userValue = user.valueOrNull;
  if (userValue == null) {
    return false;
  }
  return isLinkedAppleFor(userValue);
});

bool isLinkedAppleFor(User user) {
  return user.providerData.where((element) => element.providerId == AppleAuthProvider.PROVIDER_ID).isNotEmpty;
}

Future<bool> appleReauthentification() async {
  final provider = AppleAuthProvider();
  await FirebaseAuth.instance.currentUser?.reauthenticateWithProvider(provider);
  return true;
}
