import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:test/test.dart';

void main() {
  test('adding item increases total cost', () {
    final cart = UserProviderModel();
    final user = new User("name", "email-123", "password", "phoneNumber");
    expect(cart.user.userEmail, equals(""));
    cart.addListener(() {
      expect(cart.user.userEmail, equals("email-123"));
      expect(cart.userUid, equals("fbuid"));
    });
    cart.setUser("fbuid", user);
  });
}