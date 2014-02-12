library refresh_token_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/oauth2Provider.dart';
import 'MockDataHandler.dart';

RefreshTokenSpec() {
  group('RefreshTokenSpec', () {

    test('handle request', () {
      var refreshToken = new RefreshToken(new DemoClientCredentialFetcher());
      var request = new AuthorizationRequest({}, {"refresh_token": ["refreshToken1"]});
      GrantHandlerResult grantHandlerResult = refreshToken.handleRequest(request, new DemoDataHandler1());

      expect(grantHandlerResult.tokenType, equals('Bearer'));
      expect(grantHandlerResult.accessToken, equals('token1'));
      expect(grantHandlerResult.expiresIn, equals(3600));
      expect(grantHandlerResult.refreshToken, equals('refreshToken1'));
      expect(grantHandlerResult.scope, equals(null));
    });
  });
}

class DemoDataHandler1<U> extends DemoDataHandler<U> {
  @override
  findAuthInfoByRefreshToken(String refreshToken) => new AuthInfo(
      new DemoUser(10000, "username"), 'clientId1', null, null);

  @override
  refreshAccessToken(AuthInfo<DemoUser> authInfo, [String refreshToken]) => new AccessToken(
      "token1", refreshToken, null, 3600, new DateTime.now());
}