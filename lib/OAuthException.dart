library dartoauth2.provider;

abstract class OAuthError extends Error {
  String errorType;

  OAuthError(String description) : this.full(400, description);

  OAuthError.full(int statusCode, String description);
}

class InvalidRequest extends OAuthError {

  InvalidRequest({description: ''}) : super(description) {
    errorType = "invalid_request";
  }
}

class InvalidClient extends OAuthError {

  InvalidClient({description: ''}) : super.full(401, description) {
    errorType = "invalid_clientt";
  }
}

class UnauthorizedClient extends OAuthError {

  UnauthorizedClient({description: ''}) : super.full(401, description) {
    errorType = "unauththorized_clientt";
  }
}

class RedirectUriMismatch extends OAuthError {

  RedirectUriMismatch({description: ''}) : super.full(401, description) {
    errorType = "redirect_uri_mismatch";
  }
}

class AccessDenied extends OAuthError {

  AccessDenied({description: ''}) : super.full(401, description) {
    errorType = "access_denied";
  }
}

class UnsupportedResponseType extends OAuthError {

  UnsupportedResponseType({description: ''}) : super(description) {
    errorType = "unsupported_response_type";
  }
}

class InvalidGrant extends OAuthError {

  InvalidGrant({description: ''}) : super.full(401, description) {
    errorType = "invalid_grant";
  }
}

class UnsupportedGrantType extends OAuthError {

  UnsupportedGrantType({description: ''}) : super(description) {
    errorType = "unsupported_grant_type";
  }
}

class InvalidScope extends OAuthError {

  InvalidScope({description: ''}) : super.full(401, description) {
    errorType = "invalid_scope";
  }
}

class InvalidToken extends OAuthError {

  InvalidToken({description: ''}) : super.full(401, description) {
    errorType = "invalid_token";
  }
}

class ExpiredToken extends OAuthError {

  ExpiredToken() : super.full(401, "The access token expired") {
    errorType = "invalid_token";
  }
}

class InsufficientScope extends OAuthError {

  InsufficientScope({description: ''}) : super.full(401, description) {
    errorType = "insufficient_scope";
  }
}
