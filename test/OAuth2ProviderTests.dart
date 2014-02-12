library OAuth2Provider;

import "AuthCodeTest.dart";
import "AuthHeaderTest.dart";
import "ClientCrendentialFetcherTest.dart";
import "ClientCrendentialsTest.dart";
import "PasswordTest.dart";
import "ProtectedResourceTest.dart";
import "RefreshTokenTest.dart";
import "RequestParameterTest.dart";
import "TokenTest.dart";

main() {
  AuthorizationCodeSpec();
  AuthHeaderSpecs();
  ClientCredentialFetcherSpec();
  ClientCredentialsSpec();
  PasswordSpec();
  ProtectedResourceSpec();
  RefreshTokenSpec();
  RequestParameterSpec();
  TokenSpec();
}
