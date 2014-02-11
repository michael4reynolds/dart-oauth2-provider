library auth_header_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/GrantHandler.dart';
import 'package:dartOauth2Provider/DataHandler.dart';
import 'package:dartOauth2Provider/AuthorizationRequest.dart';
import 'package:dartOauth2Provider/ProtectedResourceRequest.dart';
import 'MockDataHandler.dart';

DemoDataHandler dataHandler1;
DemoDataHandler dataHandler2;

void createDataHandler() {
  dataHandler1 = new DemoDataHandler1<DemoUser>();
  dataHandler2 = new DemoDataHandler2<DemoUser>();
}

ProtectedResourceRequest createRequest(String authorization) =>
  new ProtectedResourceRequest({ 'Authorization': authorization }, new Map());

void main() {

  group('AuthorizationCodeSpec', () {
    setUp(createDataHandler);
    
    test('handle request', () {
      var authorizationCode = new AuthorizationCode(new DemoClientCredentialFetcher());
      var request = new AuthorizationRequest({}, {"code": ["code1"], "redirect_uri": ["http://example.com/"]});
      GrantHandlerResult grantHandlerResult = authorizationCode.handleRequest(request, dataHandler1);

      expect(grantHandlerResult.tokenType, equals('Bearer'));
      expect(grantHandlerResult.accessToken, equals('token1'));
      expect(grantHandlerResult.expiresIn, equals(3600));
      expect(grantHandlerResult.refreshToken, equals('refreshToken1'));
      expect(grantHandlerResult.scope, equals('all'));
    });

    test('handle request if redirectUrl is none', () {
      var authorizationCode = new AuthorizationCode(new DemoClientCredentialFetcher());
      var request = new AuthorizationRequest({}, {"code": ["code1"], "redirect_uri": ["http://example.com/"]});
      GrantHandlerResult grantHandlerResult = authorizationCode.handleRequest(request, dataHandler2);

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
  findAuthInfoByCode(String code) => new AuthInfo<DemoUser>(
    new DemoUser(10000, "username"), "clientId1", 'all', Uri.parse("http://example.com/"));

  @override
  createAccessToken(AuthInfo<DemoUser> authInfo) => new AccessToken(
      "token1", "refreshToken1", 'all', 3600, new DateTime.now());
}

class DemoDataHandler2<U> extends DemoDataHandler<U> {
  @override
  findAuthInfoByCode(String code) => new AuthInfo<DemoUser>(
      new DemoUser(10000, "username"), "clientId1", 'all', null);

  @override
  createAccessToken(AuthInfo<DemoUser> authInfo) => new AccessToken(
      "token1", "refreshToken1", 'all', 3600, new DateTime.now());
}