library dartoauth2.provider.endpoint;

import 'ClientCredentialFetcher.dart';
import 'GrantHandler.dart';
import 'AuthorizationRequest.dart';
import 'DataHandler.dart';
import 'OAuthException.dart';

class TokenEndpoint {

  ClientCredentialFetcher fetcher;

  Map get handlers => {
      "authorization_code" : new AuthorizationCode(fetcher),
      "refresh_token" : new RefreshToken(fetcher),
      "client_credentials" : new ClientCredentials(fetcher),
      "password" : new Password(fetcher)
  };

  handleRequest(AuthorizationRequest request, DataHandler dataHandler) {
    var grantType = request.grantType;
    if (grantType == null) {
      throw new InvalidRequest('grant_type not found');
    }

    var handler = handlers[grantType];
    if (handler == null) {
      throw new UnsupportedGrantType("the grant_type isn't supported");
    }

    var clientCredential = fetcher.fetch(request);
    if (clientCredential == null) {
      throw new InvalidRequest("client credential not found");
    }

    if (!dataHandler.validateClient(clientCredential.clientId, clientCredential.clientSecret, grantType)) {
      throw new InvalidClient();
    }
  }

}
