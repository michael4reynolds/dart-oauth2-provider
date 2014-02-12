library dartoauth2.provider;

import 'dart:io';
import 'package:dartOauth2Provider/oauth2Provider.dart';

class OAuth2Provider {

  GrantHandlerResult r;

  void issueAccessToken(DataHandler dataHandler, HttpRequest request) {
    try {
      var endpoint = new TokenEndpoint();
      endpoint.handleRequest(request, dataHandler);
      request.response.write(responseAccessToken);
      request.response.close();
    } catch (e) {
      if(e.statusCode == HttpStatus.BAD_REQUEST ) responseOAuthError(request..response.statusCode = 400, e);
      if(e.statusCode == HttpStatus.UNAUTHORIZED ) responseOAuthError(request..response.statusCode = 401, e);
    }
  }

  String get responseAccessToken => r.toJSon;


  responseOAuthError(HttpRequest result, OAuthError e) {
    result.response.headers.set('www-authenticate', "Bearer " + toOAuthErrorString(e));
  }

  String toOAuthErrorString(OAuthError e) {
    var params = new List<String>()..add("error=\"" + e.errorType + "\"");
    if(e.description != null && !e.description.isEmpty) {
      params.add("error_description=\"" + e.description + "\"");
    }
    return params.join(', ');
  }
}
