library dartoauth2.provider;

import 'dart:io';
import 'GrantHandler.dart';
import 'DataHandler.dart';
import 'OAuthException.dart';
import 'TokenEndpoint.dart';

class OAuth2Provider {

  GrantHandlerResult _r;

  OAuth2Provider([this._r]);

  void issueAccessToken(DataHandler dataHandler, [HttpRequest request]) {
    try {
      var endpoint = new TokenEndpoint();
      endpoint.handleRequest(request, dataHandler);
      request.response.write(responseAccessToken(_r));
      request.response.close();
    } catch (e) {
      if(e.statusCode == HttpStatus.BAD_REQUEST ) responseOAuthError(request..response.statusCode = 400, e);
      if(e.statusCode == HttpStatus.UNAUTHORIZED ) responseOAuthError(request..response.statusCode = 401, e);
    }
  }

  String responseAccessToken(GrantHandlerResult r) {
    return r.toJSon;
  }

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
