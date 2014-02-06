library dartoauth2.provider.protectedresource;

import 'DataHandler.dart';
import 'ProtectedResourceRequest.dart';
import 'AccessTokenFetcher.dart';
import 'OAuthException.dart';

class ProtectedResource {

  AccessTokenFetcher fetcher;

  ProtectedResource(this.fetcher);

  handleRequest(ProtectedResourceRequest request, DataHandler dataHandler) {
    var result = fetcher.fetch(request);
    var accessToken = dataHandler.findAccessToken(result.token);

    if(accessToken == null) {
      throw new InvalidToken("Invalid access token");
    }

    if (dataHandler.isAccessTokenExpired(accessToken)) {
      throw new ExpiredToken();
    }

    if(dataHandler.findAuthInfoByAccessToken(accessToken) == null){
      throw new InvalidToken("invalid access token");
    }
  }

}
