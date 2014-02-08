library oauth2_outline;

abstract class SkeletonValidator{

  SkeletonValidator(RequestValidator);

  // Ordered roughly in order of appearance in the authorization grant flow

  /// Pre- and post-authorization.

  // Simple validity check, does client exist? Not banned?
  validate_client_id(client_id, request, [args]);


  // Is the client allowed to use the supplied redirect_uri? i.e. has
  // the client previously registered this EXACT redirect uri.
  validate_redirect_uri(client_id, redirect_uri, request, [args]);


  // The redirect used if none has been supplied.
  // Prefer your clients to pre register a redirect uri rather than
  // supplying one on each authorization request.
  get_default_redirect_uri(client_id, request, [args]);


  // Is the client allowed to access the requested scopes?
  validate_scopes(client_id, scopes, client, request, [args]);


  // Scopes a client will authorize for if none are supplied in the
  // authorization request.
  get_default_scopes(client_id, request, [args]);


  // Clients should only be allowed to use one type of response type, the
  // one associated with their one allowed grant type.
  // In this case it must be "code".
  validate_response_type(client_id, response_type, client, request, [args]);


  /// Post-authorization

  // Remember to associate it with request.scopes, request.redirect_uri
  // request.client, request.state and request.user (the last is passed in
  // post_authorization credentials, i.e. { 'user': request.user}.
  save_authorization_code(client_id, code, request, [args]);


  /// Token request

  // Whichever authentication method suits you, HTTP Basic might work
  authenticate_client(request, [args]);


  // Don't allow public (non-authenticated) clients
  authenticate_client_id(client_id, request, [args]) => false;


  // Validate the code belongs to the client. Add associated scopes,
  // state and user to request.scopes, request.state and request.user.
  validate_code(client_id, code, client, request, [args]);


  // You did save the redirect uri with the authorization code right?
  confirm_redirect_uri(client_id, code, redirect_uri, client, [args]);


  // Clients should only be allowed to use one type of grant.
  // In this case, it must be "authorization_code" or "refresh_token"
  validate_grant_type(client_id, grant_type, client, request, [args]);


  // Remember to associate it with request.scopes, request.user and
  // request.client. The two former will be set when you validate
  // the authorization code. Don't forget to save both the
  // access_token and the refresh_token and set expiration for the
  // access_token to now + expires_in seconds.
  save_bearer_token(token, request, [args]);


  // Authorization codes are use once, invalidate it when a Bearer token
  // has been acquired.
  invalidate_authorization_code(client_id, code, request, [args]);


  /// Protected resource request

  // Remember to check expiration and scope membership
  validate_bearer_token(token, scopes, request);


  /// Token refresh request

  // Obtain the token associated with the given refresh_token and
  // return its scopes, these will be passed on to the refreshed
  // access token if the client did not specify a scope during the
  // request.
  get_original_scopes(refresh_token, request, [args]);

}