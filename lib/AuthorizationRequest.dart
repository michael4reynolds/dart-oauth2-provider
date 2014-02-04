library dartoauth2.provider;

import 'RequestBase.dart';

class AuthorizationRequest extends RequestBase {

  AuthorizationRequest(Map<String, String> headers, Map<String, List<String>> params)
    : super(headers, params);

  String get grantType => param("grant_type");
  String get clientId => param("client_id");
  String get clientSecret => param("client_secret");
  String get scope => param("scope");
  String get redirectUri => param("redirect_uri");
  String get requireCode => requireParam("code");
  String get requireUsername => requireParam("username");
  String get requirePassword => requireParam("password");
  String get requireRefreshToken => requireParam("refresh_token");
}
