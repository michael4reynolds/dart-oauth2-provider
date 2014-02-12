library dartoauth2.provider.credfetcher;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'AuthorizationRequest.dart';

class ClientCredential {
  String clientId, clientSecret;

  ClientCredential(this.clientId, this.clientSecret);
}

class ClientCredentialFetcher {
  String clientId;
  String clientSecret;

  ClientCredentialFetcher([this.clientId, this.clientSecret]);

  ClientCredential fetch(AuthorizationRequest request) {
    var authorization = request.header('Authorization');
    if (authorization != null && authorization.length > 5) {
      var decoded = UTF8.decode(CryptoUtils.base64StringToBytes(authorization.substring(6)));
      List<String> parts = decoded.split(':');
      if (parts.length > 0) {
        clientId = parts[0];
        parts.removeAt(0);
        clientSecret = parts.join(':');
        return new ClientCredential(clientId, clientSecret);
      }
    } else if (request.params != null && request.params.length > 0) {
        if (request.params['client_id'] != null) {
          clientId = request.params['client_id'][0];
          clientSecret = request.params['client_secret'] != null ? request.params['client_secret'][0] : null;
          return new ClientCredential(clientId, clientSecret);
        }
    }
  }
}