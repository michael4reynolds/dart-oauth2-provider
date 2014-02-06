library dartoauth2.provider;

import 'OAuthException.dart';

class RequestBase {
  final Map<String, String> headers;
  final Map<String, List<String>> params;

  RequestBase(this.headers, this.params);

  String header(String name) => headers[name];

  String requireHeader(String name) {
    if (headers[name] != null)
      return headers[name];
    throw new InvalidRequest("required header: $name");
  }

  String param(String name) => params[name] != null ? params[name].first : null;

  String requireParam(String name) {
    if (param(name) != null)
      return param(name);
    throw new InvalidRequest("required parameter: $name");
  }
}
