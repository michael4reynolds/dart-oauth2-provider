library dartoauth2.provider.granthandler;

import 'DataHandler.dart';
import 'AuthorizationRequest.dart';
import 'ClientCredentialFetcher.dart';
import 'OAuthException.dart';

class GrantHandlerResult {
  String tokenType;
  String accessToken;
  int expiresIn;
  String refreshToken;
  String scope;

  GrantHandlerResult(this.tokenType, this.accessToken, this.expiresIn, this.refreshToken, this.scope);

  String get toJSon =>
  '{'
    '"tokenType": $tokenType, '
    '"accessToken": $accessToken, '
    '"expiresIn": $expiresIn, '
    '"refreshToken": $refreshToken, '
    '"scope": $scope'
  '}';
}

abstract class GrantHandler {
  AccessToken accessToken;

  GrantHandlerResult handleRequest(AuthorizationRequest request, DataHandler dataHandler);

  GrantHandlerResult issueAccessToken(DataHandler dataHandler, AuthInfo authInfo) {
    accessToken = dataHandler.getStoredAccessToken(authInfo);
    if (accessToken == null) {
      accessToken = dataHandler.createAccessToken(authInfo);
    } else if (dataHandler.isAccessTokenExpired(accessToken)) {
      accessToken = dataHandler.refreshAccessToken(authInfo) != null
                           ? dataHandler.refreshAccessToken(authInfo)
                           : dataHandler.createAccessToken(authInfo);
    }

    return new GrantHandlerResult(
        "Bearer",
        accessToken.token,
        accessToken.expiresIn,
        accessToken.refreshToken,
        accessToken.scope
    );

  }
}

class RefreshToken extends GrantHandler {
  ClientCredentialFetcher clientCredentialFetcher;

  RefreshToken(this.clientCredentialFetcher);

  handleRequest(AuthorizationRequest request, DataHandler dataHandler) {
    var clientCredential = clientCredentialFetcher.fetch(request);
    if (clientCredential == null) {
      throw new InvalidRequest('BadRequest');
    }
    var refreshToken = request.requireRefreshToken;
    var authInfo = dataHandler.findAuthInfoByRefreshToken(refreshToken);
    if(authInfo == null || authInfo.clientId != clientCredential.clientId) {
      throw new InvalidClient();
    }

    accessToken = dataHandler.refreshAccessToken(authInfo, refreshToken);
    return new GrantHandlerResult(
        "Bearer",
        accessToken.token,
        accessToken.expiresIn,
        accessToken.refreshToken,
        accessToken.scope
    );
  }
}

class Password extends GrantHandler {
  ClientCredentialFetcher clientCredentialFetcher;

  Password(this.clientCredentialFetcher);

  handleRequest(AuthorizationRequest request, DataHandler dataHandler) {
    var clientCredential = clientCredentialFetcher.fetch(request);
    if (clientCredential == null) {
      throw new InvalidRequest('BadRequest');
    }
    var username = request.requireUsername;
    var password = request.requirePassword;
    var user = dataHandler.findUser(username, password);
    if (user == null) {
      throw new InvalidGrant();
    }
    var scope = request.scope;
    var clientId = clientCredential.clientId;
    var authInfo = new AuthInfo(user, clientId, scope, null);

    return issueAccessToken(dataHandler, authInfo);
  }
}

class ClientCredentials extends GrantHandler {
  ClientCredentialFetcher clientCredentialFetcher;

  ClientCredentials(this.clientCredentialFetcher);

  handleRequest(AuthorizationRequest request, DataHandler dataHandler) {
    var clientCredential = clientCredentialFetcher.fetch(request);
    if (clientCredential == null) {
      throw new InvalidRequest('BadRequest');
    }
    var clientSecret = clientCredential.clientSecret;
    var clientId = clientCredential.clientId;
    var scope = request.scope;
    var user = dataHandler.findClientUser(clientId, clientSecret, scope);
    if (user == null) {
      throw new InvalidGrant();
    }
    var authInfo = new AuthInfo(user, clientId, scope, null);

    return issueAccessToken(dataHandler, authInfo);
  }
}

class AuthorizationCode extends GrantHandler {
  ClientCredentialFetcher clientCredentialFetcher;

  AuthorizationCode(this.clientCredentialFetcher);

  handleRequest(AuthorizationRequest request, DataHandler dataHandler) {
    var clientCredential = clientCredentialFetcher.fetch(request);
    if (clientCredential == null) {
      throw new InvalidRequest('BadRequest');
    }
    var clientId = clientCredential.clientId;
    var code = request.requireCode;
    var redirectUri = request.redirectUri;
    var authInfo = dataHandler.findAuthInfoByCode(code);
    if(authInfo == null || authInfo.clientId != clientId) {
      throw new InvalidClient();
    }

    if (authInfo.redirectUri != null && authInfo.redirectUri.toString() != redirectUri) {
      throw new RedirectUriMismatch();
    }

    return issueAccessToken(dataHandler, authInfo);
  }
}

