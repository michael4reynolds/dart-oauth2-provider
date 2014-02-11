library data_handler_test;

import 'package:dartOauth2Provider/DataHandler.dart';
import 'package:dartOauth2Provider/AuthorizationRequest.dart';
import 'package:dartOauth2Provider/ClientCredentialFetcher.dart';

class DemoUser {
  int id;
  String name;

  DemoUser(this.id, this.name);
}

class DemoDataHandler<U> extends DataHandler {
  bool validateClient(String clientId, String clientSecret, String grantType)=> false;
  findUser(String username, String password)=> null;
  AccessToken createAccessToken(AuthInfo authInfo)=> new AccessToken('', '', '', 0, new DateTime.now());
  AccessToken getStoredAccessToken(AuthInfo authInfo)=> null;
  AuthInfo findAuthInfoByCode(String code)=> null;
  AuthInfo findAuthInfoByRefreshToken(String refreshToken)=> null;
  findClientUser(String clientId, String clientSecret, String scope)=> null;
  AccessToken findAccessToken(String token)=> null;
  AuthInfo findAuthInfoByAccessToken(AccessToken accessToken)=> null;
  AccessToken refreshAccessToken(AuthInfo authInfo, [String refreshToken])=> new AccessToken('', '', '', 0, new DateTime.now());
  isAccessTokenExpired(AccessToken accessToken) => super.isAccessTokenExpired(accessToken);
}

class DemoClientCredentialFetcher extends ClientCredentialFetcher {

  DemoClientCredentialFetcher([clientId, clientSecret]) : super(clientId, clientSecret);

  @override
  fetch([AuthorizationRequest request]) => new ClientCredential("clientId1", "clientSecret1");
}