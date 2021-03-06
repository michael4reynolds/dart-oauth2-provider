library dartoauth2.provider.datahandler;

class AccessTokenRequest<U> {
  String clientId;
  String clientSecret;
  U user;

  AccessTokenRequest(this.clientId, this.clientSecret, this.user);
}

class AccessToken {
  String token;
  String refreshToken;
  String scope;
  int expiresIn;
  DateTime createdAt;

  AccessToken(this.token, this.refreshToken, this.scope, this.expiresIn, this.createdAt);
}

class AuthInfo<U> {
  U user;
  String clientId;
  String scope;
  Uri redirectUri;

  AuthInfo(this.user, this.clientId, this.scope, this.redirectUri);
}

abstract class DataHandler<U> {

  bool validateClient(String clientId, String clientSecret, String grantType);

  U findUser(String username, String password);

  AccessToken createAccessToken(AuthInfo authInfo);

  AccessToken getStoredAccessToken(AuthInfo authInfo);

  AccessToken refreshAccessToken(AuthInfo authInfo, [String refreshToken]);

  AuthInfo findAuthInfoByCode(String code);

  AuthInfo findAuthInfoByRefreshToken(String refreshToken);

  U findClientUser(String clientId, String clientSecret, String scope);

  AccessToken findAccessToken(String token);

  AuthInfo findAuthInfoByAccessToken(AccessToken accessToken);

  bool isAccessTokenExpired(AccessToken accessToken) {
    if(accessToken == null || accessToken.expiresIn == null) return false;

    var expiration =
    accessToken.createdAt.add(new Duration(seconds: accessToken.expiresIn));
    return expiration.isBefore(new DateTime.now());
  }
}
