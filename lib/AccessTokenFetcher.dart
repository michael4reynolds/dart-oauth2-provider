library dartoauth2.provider.accesstokenfetcher;

import 'ProtectedResourceRequest.dart';
import 'OAuthException.dart';

class FetchResult {
  String token;
  Map<String, String> params;

  FetchResult(this.token, this.params);
}

abstract class AccessTokenFetcher {
  bool matches(ProtectedResourceRequest request);

  FetchResult fetch(ProtectedResourceRequest request);
}

class  RequestParameter extends AccessTokenFetcher {
  bool matches(ProtectedResourceRequest request) =>
    request.oauthToken != null || request.accessToken != null;

  FetchResult fetch(ProtectedResourceRequest request) {
    var t = request.oauthToken;
    if (t == null) {
      t = request.requireAccessToken;
    }
    Map<String, String> param = request.params.values.isNotEmpty
                               ? request.params.values.first : null;
    ["oauth_token", "access_token"].forEach((k) => param.remove(k));
    return new FetchResult(t, param);
  }
}

class AuthHeader extends AccessTokenFetcher {
  final REGEXP_AUTHORIZATION = new RegExp(r'^\s*(OAuth|Bearer)\s+([^\s\,]*)');
  final REGEXP_TRIM = new RegExp(r'^\s*,\s*');
  final REGEXP_DIV_COMMA = new RegExp(r',\s*');

  bool matches(ProtectedResourceRequest request) {
    var header = request.header("Authorization");
    if (header != null) {
      return REGEXP_AUTHORIZATION.firstMatch(header) != null;
    }
    return false;
  }

  FetchResult fetch(ProtectedResourceRequest request) {
    var header = request.requireHeader("Authorization");
    var matcher = REGEXP_AUTHORIZATION.firstMatch(header);
    if (matcher == null) {
      throw new InvalidRequest('parse() method was called when match() result was false.');
    }

    String token = matcher.group(2);
    int end = matcher.end;
    var params = new Map<String, String>();
    if (header.length != end) {
      var trimmedHeader = header.substring(end).replaceFirst(REGEXP_TRIM, '');
      trimmedHeader.split(REGEXP_DIV_COMMA).forEach((exp) {
        var list = exp.split("=");
        String key = list[0];
        String value = list[1]
          .replaceFirst(new RegExp('^\"'), '')
          .replaceFirst(new RegExp(r'"$'), '');
        params.addAll({key: Uri.decodeComponent(value)});
      });
    }

    return new FetchResult(token, params);
  }
}