library auth_header_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/DataHandler.dart';
import 'package:dartOauth2Provider/ProtectedResource.dart';
import 'package:dartOauth2Provider/ProtectedResourceRequest.dart';
import 'package:dartOauth2Provider/OAuthException.dart';
import 'MockDataHandler.dart';

DemoDataHandler1 successfulDataHandler;
DemoDataHandler2 dataHandler;

void createDataHandler() {
  successfulDataHandler = new DemoDataHandler1();
  dataHandler = new DemoDataHandler2();
}

void main() {

  group('ProtectedResourceSpec', () {
    setUp(createDataHandler);
    
    test('be handled request with token into header', () {
      var request = new ProtectedResourceRequest(
          {"Authorization": "OAuth token1"},
          {"username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(new ProtectedResource().handleRequest(request, successfulDataHandler), isTrue);
    });

    test('be handled request with token into body', () {
      var request = new ProtectedResourceRequest(
          {},
          {"access_token": ["token1"], "username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(() => new ProtectedResource().handleRequest(request, successfulDataHandler), returnsNormally);
    });

    test('be lost expired', () {
      var request = new ProtectedResourceRequest(
          {"Authorization": "OAuth token1"},
          {"username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(() => new ProtectedResource().handleRequest(request, dataHandler), throwsA(new isInstanceOf<ExpiredToken>()));
    });

    test('be invalid request without token', () {
      var request = new ProtectedResourceRequest(
          {},
          {"username": ["user"], 'password': ['pass'], 'scope': ['all']});
      expect(() => new ProtectedResource().handleRequest(request, successfulDataHandler), throwsA(new isInstanceOf<InvalidRequest>()));
    });

  });
}

class DemoDataHandler1<U> extends DemoDataHandler<U> {

  @override
  findAccessToken(String token) => new AccessToken(
      "token1", "refreshToken1", 'all', 3600, new DateTime.now());

  @override
  findAuthInfoByAccessToken(AccessToken accessToken) => new AuthInfo(
    new DemoUser(10000, "username"), "clientId1", 'all', null);

}

class DemoDataHandler2<U> extends DemoDataHandler<U> {

  @override
  findAccessToken(String token) => new AccessToken(
      "token1", "refreshToken1", 'all', 3600, new DateTime.now().subtract(new Duration(days: 45)));

  @override
  findAuthInfoByAccessToken(AccessToken accessToken) => new AuthInfo(
    new DemoUser(10000, "username"), "clientId1", 'all', null);

}