library client_credential_fetcher_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/AuthorizationRequest.dart';
import 'package:dartOauth2Provider/ClientCredentialFetcher.dart';

ClientCredentialFetcher clientCredentialFetcher;

void main() {
  group('ClientCredentialFetcherSpec', () {
    setUp(() => clientCredentialFetcher = new ClientCredentialFetcher());
    
    test('fetch Basic64', () {
      var request = new AuthorizationRequest({"Authorization":"Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU="}, {});
      var c = clientCredentialFetcher.fetch(request);
      expect(c.clientId, equals('client_id_value'));
      expect(c.clientSecret, equals('client_secret_value'));
    });

    test('fetch empty client_secret', () {
      var request = new AuthorizationRequest({"Authorization":"Basic Y2xpZW50X2lkX3ZhbHVlOg=="}, {});
      var c = clientCredentialFetcher.fetch(request);
      expect(c.clientId, equals('client_id_value'));
      expect(c.clientSecret, equals(''));
    });

    test('not fetch no Authorization key in header', () {
      var request = new AuthorizationRequest({"authorizatio":"Basic Y2xpZW50X2lkX3ZhbHVlOmNsaWVudF9zZWNyZXRfdmFsdWU="}, {});
      var c = clientCredentialFetcher.fetch(request);
      expect(c, isNull);
    });

    test('not fetch invalidate Base64', () {
      var request = new AuthorizationRequest({"authorizatio":"Basic basic"}, {});
      var c = clientCredentialFetcher.fetch(request);
      expect(c, isNull);
    });

    test('fetch parameter', () {
      var request = new AuthorizationRequest({}, {"client_id": ["client_id_value"], "client_secret": ["client_secret_value"]});
      var c = clientCredentialFetcher.fetch(request);
      expect(c.clientId, equals('client_id_value'));
      expect(c.clientSecret, equals('client_secret_value'));
    });

    test('omit client_secret', () {
      var c = clientCredentialFetcher.fetch(new AuthorizationRequest({}, {"client_id": ["client_id_value"]}));
      expect(c.clientId, equals('client_id_value'));
      expect(c.clientSecret, isNull);
    });

    test('not fetch missing parameter', () {
      var c = clientCredentialFetcher.fetch(new AuthorizationRequest({}, {"client_secret": ["client_secret_value"]}));
      expect(c, isNull);
    });

    test('not fetch invalid parameter', () {
      var request = new AuthorizationRequest({"Authorization":""}, {});
      var c = clientCredentialFetcher.fetch(request);
      expect(c, isNull);
    });
  });
}
