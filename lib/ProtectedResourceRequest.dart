library dartoauth2.provider;

import 'RequestBase.dart';

class ProtectedResourceRequest extends RequestBase {

  ProtectedResourceRequest(Map<String, String> headers, Map<String, List<String>> params)
    : super(headers, params);

  String get oauthToken => param("oauth_token");

  String get accessToken => param("access_token");

  String get requireAccessToken => requireParam("access_token");
}
