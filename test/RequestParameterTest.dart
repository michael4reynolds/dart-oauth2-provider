library request_parameter_test;

import 'package:unittest/unittest.dart';
import 'package:dartOauth2Provider/oauth2Provider.dart';
import 'MockDataHandler.dart';

RequestParameter requestParameter;

void createDataHandler() {
  requestParameter = new RequestParameter();
}

ProtectedResourceRequest createRequest(String oauthToken, String accessToken, [Map<String, List<String>> another = const {}]) {
  Map params = new Map<String, List<String>>();
  if(oauthToken != null) {
    params.addAll({'oauth_token': [oauthToken]});
  }
  if(accessToken != null) {
    params.addAll({'access_token': [accessToken]});
  }
  if(another != null) {
    params.addAll(another);
  }

  return new ProtectedResourceRequest({}, params);
}

RequestParameterSpec() {

  group('RequestParameterSpec', () {
    setUp(createDataHandler);
    
    test('match RequestParameter', () {
      expect(requestParameter.matches(createRequest('token1', null)), isTrue);
      expect(requestParameter.matches(createRequest(null, 'token2')), isTrue);
      expect(requestParameter.matches(createRequest('token1', 'token2')), isTrue);
    });

    test("doesn't match RequestParameter", () {
      expect(requestParameter.matches(createRequest(null, null)), isFalse);
    });

    test('fetch only oauth token parameter', () {
      var result = requestParameter.fetch(createRequest('token1', null));
      expect(result.token, equals('token1'));
      expect(result.params, equals({}));
    });

    test('fetch only access token parameter', () {
      var result = requestParameter.fetch(createRequest(null, 'token2'));
      expect(result.token, equals('token2'));
      expect(result.params, equals({}));
    });

    test('fetch with another parameter', () {
      var result = requestParameter.fetch(createRequest(null, 'token2', {'foo': ['bar']}));
      expect(result.token, equals('token2'));
      expect(result.params['foo'], equals('bar'));
    });

    test('fetch illegal parameter then throws exception', () {
      expect(() => requestParameter.fetch(createRequest(null, null)), throwsA(new isInstanceOf<InvalidRequest>()));
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