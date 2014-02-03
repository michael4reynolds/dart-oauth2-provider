library dartoauth2.provider;

import 'OAuthException.dart';

class RequestBase {

  RequestBase(Map<String, String> headers, Map<String, String> params) {
    String header(String name) => headers[name];
    String requireHeader(String name) {
     if( headers[name] != null)
       return headers[name];
    }
    throw new InvalidRequest("required header: $name");
  }
}
