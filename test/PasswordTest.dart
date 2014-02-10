library password_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/AuthorizationRequest.dart';
import 'package:dartOauth2Provider/DataHandler.dart';
import 'package:dartOauth2Provider/GrantHandler.dart';
import 'MockDataHandler.dart';

void main() {
  group('PasswordSpec', () {

    test('handle request', () {
      var password = new Password(new DemoClientCredentialFetcher());
      var request = new AuthorizationRequest({}, {"username": ["user"], 'password': ['pass'], 'scope': ['all']});
      GrantHandlerResult grantHandlerResult = password.handleRequest(request, new DemoDataHandler1());

      expect(grantHandlerResult.tokenType, equals('Bearer'));
      expect(grantHandlerResult.accessToken, equals('token1'));
      expect(grantHandlerResult.expiresIn, equals(3600));
      expect(grantHandlerResult.refreshToken, equals('refreshToken1'));
      expect(grantHandlerResult.scope, equals('all'));
    });
  });
}

class DemoDataHandler1<U> extends DemoDataHandler<U> {
  @override
  findUser(String username, String password) => new DemoUser(10000, "username");

  @override
  createAccessToken(AuthInfo<DemoUser> authInfo) => new AccessToken(
      "token1", 'refreshToken1', 'all', 3600, new DateTime.now());
}