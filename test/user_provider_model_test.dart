import 'dart:math';

import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:test/test.dart';

void main() {
  final user = new User("name", "email-123", "password", "phoneNumber", userId: 0);
  test('login user', () {
    final cart = UserProviderModel(new TestAuthAdapter(user: user));
    expect(cart.user, equals(null));
    cart.addListener(() {
      expect(cart.user!.userEmail, equals("email-123"));
      expect(cart.userUid, equals("fbuid"));
    });
    expect(() => cart.login("fbuid"), returnsNormally);
  });
  test('login user error', () async {
    final cart = UserProviderModel(new TestAuthAdapter(loginError: new Error(), user: user));
    expect(cart.user, equals(null));
    try {
      await cart.login("fbuid");
      fail("exception not thrown");
    } catch (e) {
      expect(e.toString(), equals("test error"));
    }
  });
}

class TestAuthAdapter implements AuthAdapter {
  final User user;
  final Error? loginError;
  TestAuthAdapter({required this.user, this.loginError});
  @override
  Future<User> login(String uid) {
    return Future.delayed(Duration.zero, () {
      if (loginError != null) {
        throw("test error");
      }
      return user;
    });
  }

  @override
  void logout() {

  }

}