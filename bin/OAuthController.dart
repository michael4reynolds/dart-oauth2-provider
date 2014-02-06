import 'package:dartOauth2Provider/OAuth2Provider.dart';

class OAuth2Controller extends Object with OAuth2Provider {

  DataHandler myDataHandler;

  accessToken(authInfo) {
    var handlerResult = issueAccessToken(myDataHandler, authInfo);
  }
}

//Route
//  POST    /oauth2/access_token    controllers.OAuth2Controller.accessToken

/*
  authorize(myDataHandler()) {
    val user = authInfo.user // User is defined on your system
    // access resource for the user
   }
 */
