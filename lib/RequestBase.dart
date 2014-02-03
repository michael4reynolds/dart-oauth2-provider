library dartoauth2.provider;

import 'OAuthException.dart';

class RequestBase {
  final Map<String, String> _headers;
  final Map<String, List<String>>_params;

  RequestBase(this._headers, this._params);

  String header(String name) => _headers[name];

  String requireHeader(String name) {
    if (_headers[name] != null)
      return _headers[name];
    throw new InvalidRequest("required header: $name");
  }

  String param(String name) => _params[name] != null ? _params[name].first : null;

  String requireParam(String name) {
    if (param(name) != null)
      return param(name);
    throw new InvalidRequest("required parameter: $name");
  }
}
