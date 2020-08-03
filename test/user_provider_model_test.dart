import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:test/test.dart';

void main() {
  test('login user', () {
    final user = new User("name", "email-123", "password", "phoneNumber");
    final cart = UserProviderModel(new TestAuthAdapter(user: user));
    expect(cart.user, equals(null));
    cart.addListener(() {
      expect(cart.user.userEmail, equals("email-123"));
      expect(cart.userUid, equals("fbuid"));
    });
    cart.login("fbuid");
  });
}

class TestAuthAdapter implements AuthAdapter {
  final User user;
  final Error loginError;
  TestAuthAdapter({this.user, this.loginError});
  @override
  Future<User> login(String uid) {
    return Future.delayed(Duration.zero, () {
      return user;
    });
  }

  @override
  void logout() {

  }

}