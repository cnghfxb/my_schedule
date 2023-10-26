//注册
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

Future<String> signUpUser({
  required String username,
  required String password,
  required String email,
  String? phoneNumber,
}) async {
  try {
    final userAttributes = {
      AuthUserAttributeKey.email: email,
      if (phoneNumber != null) AuthUserAttributeKey.phoneNumber: phoneNumber,
      // additional attributes as needed
    };
    final result = await Amplify.Auth.signUp(
      username: username,
      password: password,
      options: SignUpOptions(
        userAttributes: userAttributes,
      ),
    );
    print(result);
    if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
      return result.userId as String;
    } else {
      throw AuthException;
    }
  } on AuthException catch (e) {
    safePrint('Error signing up user: ${e.message}');
    if (e.message == 'User already exists') {
      print('1111');
      return 'UsernameExistsException';
    } else {
      print('222');
      rethrow;
    }
  }
}

//注册，验证码确认
Future<void> confirmUser({
  required String username,
  required String confirmationCode,
}) async {
  try {
    final result = await Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: confirmationCode,
    );
    print(result);
    if (result.nextStep.signUpStep != AuthSignUpStep.done) throw AuthException;
  } on AuthException catch (e) {
    safePrint('Error confirming user: ${e.message}');
    rethrow;
  }
}

//登录
Future<void> signInUser(String username, String password) async {
  try {
    await Amplify.Auth.signIn(
      username: username,
      password: password,
    );
  } on AuthException catch (e) {
    safePrint('Error signing in: ${e.message}');
    rethrow;
  }
}

//退出登录
Future<void> signOutCurrentUser() async {
  final result = await Amplify.Auth.signOut();
  if (result is CognitoCompleteSignOut) {
    safePrint('Sign out completed successfully');
  } else if (result is CognitoFailedSignOut) {
    safePrint('Error signing user out: ${result.exception.message}');
  }
}

Future<void> deleteUser() async {
  try {
    await Amplify.Auth.deleteUser();
    safePrint('Delete user succeeded');
  } on AuthException catch (e) {
    safePrint('Delete user failed with error: $e');
  }
}

Future<bool> isUserSignedIn() async {
  final result = await Amplify.Auth.fetchAuthSession();
  return result.isSignedIn;
}
