library dartoauth2.provider.credfetcher;

import 'package:crypto/crypto.dart';
import 'AuthorizationRequest.dart';

class ClientCredential {
  String clientId, clientSecret;

  ClientCredential(this.clientId, this.clientSecret);
}

class ClientCredentialFetcher {
  String clientId;
  String clientSecret;

  ClientCredentialFetcher(this.clientId, this.clientSecret);

  ClientCredential fetch(AuthorizationRequest request) {
    var authorization = request.header('Authorization');
    if (authorization != null && authorization.length > 5) {
      var decoded = CryptoUtils.bytesToBase64(authorization.substring(6).codeUnits);
      List<String> parts = decoded.indexOf(':', 2);
      if (parts.length > 0) {
        clientId = parts[0];
        clientSecret = parts[1] != null ? parts[1] : '';
        return new ClientCredential(clientId, clientSecret);
      }
    }
  }
}