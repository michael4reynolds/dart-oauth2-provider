library token_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/DataHandler.dart';
import 'package:dartOauth2Provider/AuthorizationRequest.dart';
import 'package:dartOauth2Provider/OAuthException.dart';
import 'package:dartOauth2Provider/TokenEndpoint.dart';
import 'MockDataHandler.dart';

DemoDataHandler1 successfulDataHandler;
TokenEndpoint tokenEndpoint;

void createDataHandler() {
  successfulDataHandler = new DemoDataHandler1();
  tokenEndpoint = new TokenEndpoint();
}

void main() {

  group('TokenSpec', () {
    setUp(createDataHandler);

    test('be handled request with token into header', () {
      var request = new AuthorizationRequest(
          {"Authorization": "Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU="},
          {"grant_type": ["password"], "username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(tokenEndpoint.handleRequest(request, successfulDataHandler), isTrue);
    });

    test("be error if grant type doesn't exist", () {
      var request = new AuthorizationRequest(
          {"Authorization": "Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU="},
          {"username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(() => tokenEndpoint.handleRequest(request, successfulDataHandler), throwsA(new isInstanceOf<InvalidRequest>()));
    });

    test("be error if grant type is wrong", () {
      var request = new AuthorizationRequest(
          {"Authorization": "Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU="},
          {"grant_type": ["test"], "username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(() => tokenEndpoint.handleRequest(request, successfulDataHandler), throwsA(new isInstanceOf<UnsupportedGrantType>()));
    });

    test("be invalid request without client credential", () {
      var request = new AuthorizationRequest(
          {},
          {"grant_type": ["password"], "username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(() => tokenEndpoint.handleRequest(request, successfulDataHandler), throwsA(new isInstanceOf<InvalidRequest>()));
    });

    test("be invalid client if client information is wrong", () {
      var request = new AuthorizationRequest(
          {"Authorization": "Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU="},
          {"grant_type": ["password"], "username": ["user"], 'password': ['pass'], 'scope': ['all']});
      var dataHandler = new DemoDataHandler2();
      expect(() => tokenEndpoint.handleRequest(request, dataHandler), throwsA(new isInstanceOf<InvalidClient>()));
    });

  });
}

class DemoDataHandler1<U> extends DemoDataHandler<U> {

  @override
  validateClient(String clientId, String clientSecret, String grantType) => true;

  @override
  findUser(String username, String password) => new DemoUser(10000, "username");

  @override
  createAccessToken(AuthInfo<DemoUser> authInfo) => new AccessToken(
      "token1", null, 'all', 3600, new DateTime.now());

}

class DemoDataHandler2<U> extends DemoDataHandler<U> {

  @override
  validateClient(String clientId, String clientSecret, String grantType) => false;

}