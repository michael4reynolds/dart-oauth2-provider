library auth_header_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/oauth2Provider.dart';

AuthHeader authHeader;

void createAuthHeader() {
  authHeader = new AuthHeader();
}

ProtectedResourceRequest createRequest(String authorization) =>
  new ProtectedResourceRequest({ 'Authorization': authorization }, new Map());

AuthHeaderSpecs() {

  group('AuthHeaderSpecs', () {
    setUp(createAuthHeader);

    test('match AuthHeader from OAuth', () {
      expect(authHeader.matches(createRequest('OAuth token1')), isTrue);
      expect(authHeader.matches(createRequest(' OAuth token1')), isTrue);
    });

    test('match AuthHeader from Bearer', () {
      expect(authHeader.matches(createRequest('Bearer token1')), isTrue);
      expect(authHeader.matches(createRequest(' Bearer token1')), isTrue);
    });

    test("doesn't match AuthHeader from OAuth", () {
      expect(authHeader.matches(createRequest(null)), isFalse);
      expect(authHeader.matches(createRequest('OAuth')), isFalse);
      expect(authHeader.matches(createRequest('OAtu token1')), isFalse);
      expect(authHeader.matches(createRequest('oauth token1')), isFalse);
    });

    test("doesn't match AuthHeader from Bearer", () {
      expect(authHeader.matches(createRequest(null)), isFalse);
      expect(authHeader.matches(createRequest('Bearer')), isFalse);
      expect(authHeader.matches(createRequest('Beare token1')), isFalse);
      expect(authHeader.matches(createRequest('bearer token1')), isFalse);
    });

    test("fetch parameter from OAuth", () {
      var result = authHeader.fetch(createRequest('OAuth access_token_value,algorithm="hmac-sha256",nonce="s8djwd",signature="wOJIO9A2W5mFwDgiDvZbTSMK%2FPY%3D",timestamp="137131200"'));
      expect(result.token, equals('access_token_value'));
      expect(result.params['algorithm'], equals('hmac-sha256'));
      expect(result.params['nonce'], equals('s8djwd'));
      expect(result.params['signature'], equals('wOJIO9A2W5mFwDgiDvZbTSMK/PY='));
      expect(result.params['timestamp'], equals('137131200'));
    });

    test("fetch parameter from Bearer", () {
      var result = authHeader.fetch(createRequest('Bearer access_token_value,algorithm="hmac-sha256",nonce="s8djwd",signature="wOJIO9A2W5mFwDgiDvZbTSMK%2FPY%3D",timestamp="137131200"'));
      expect(result.token, equals('access_token_value'));
      expect(result.params['algorithm'], equals('hmac-sha256'));
      expect(result.params['nonce'], equals('s8djwd'));
      expect(result.params['signature'], equals('wOJIO9A2W5mFwDgiDvZbTSMK/PY='));
      expect(result.params['timestamp'], equals('137131200'));
    });

    test("fetch illegal parameter then throws exception", () {
      expect(() => authHeader.fetch(createRequest(null)), throwsA(new isInstanceOf<InvalidRequest>()));
      expect(() => authHeader.fetch(createRequest('evil')), throwsA(new isInstanceOf<InvalidRequest>()));
    });
  });
}



