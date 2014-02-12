library client_credentials_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/oauth2Provider.dart';
import 'MockDataHandler.dart';

ClientCredentialsSpec() {
  group('ClientCredentialsSpec', () {

    test('handle request', () {
      var clientCredentials = new ClientCredentials(new DemoClientCredentialFetcher());
      var request = new AuthorizationRequest({}, {"scope": ["all"]});
      GrantHandlerResult grantHandlerResult = clientCredentials.handleRequest(request, new DemoDataHandler1());

      expect(grantHandlerResult.tokenType, equals('Bearer'));
      expect(grantHandlerResult.accessToken, equals('token1'));
      expect(grantHandlerResult.expiresIn, equals(3600));
      expect(grantHandlerResult.refreshToken, equals(null));
      expect(grantHandlerResult.scope, equals('all'));
    });
  });
}

class DemoDataHandler1<U> extends DemoDataHandler<U> {
  @override
  findClientUser(String clientId, String clientSecret, String scope) => new DemoUser(10000, "username");

  @override
  createAccessToken(AuthInfo<DemoUser> authInfo) => new AccessToken(
      "token1", null, 'all', 3600, new DateTime.now());
}