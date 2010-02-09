/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.constants
{
	public class YammerErrorTypes
	{
		/** Internal error occurred; try again later.  */
		public static const INTERNAL_SERVER_ERROR:int = 50;
		
		/** The requested service is unreachable or there was bad api request */
		public static const STREAM_ERROR:int = 2032;
		
		/** This error is thrown when the server is being restarted */
		public static const SERVER_UNREACHABLE:int = 1085;
		
		/** The requested service is unreachable */
		public static const NO_NETWORK_CONNECTION:int = 503;
		
		/** The requested service is unreachable */
		public static const NETWORK_CONNECTION_UNAVAILABLE:int = 0;
		
		/** The requested service is unreachable */
		public static const INVALID_LOGIN_ERROR:int = 501;
		
		/** Internal server error. */
		public static const INTERNAL_SERVER_ERROR_STATUS:int = 500;
		
		/** The requested service is unreachable */
		public static const UNAUTHORIZED_STATUS:int = 401;
		
		/** Generic database error, error in database call. */
		public static const GENERIC_DATABASE_ERROR:int = 100;
		
		/** Error occurred during file upload */
		public static const UPLOAD_FILE_ERROR:int = 3302;	
		
		/** Error occurred because of API Rate limiting */
		public static const FORBIDDEN_STATUS:int = 403;	
		
		/** Unknown consumer key. */
		public static const UNKNOWN_CONSUMER_KEY:int = 15;
		
		/** Oauth_token parameter required. */
		public static const UNKNOWN_TOKEN:int = 21;
		
		/** Unsupported signature method. */
		public static const UNSUPPORTED_SIGNATURE_METHOD:int = 22;
		
		/** Unsupported signature method. */
		public static const INVALID_OAUTH_SIGNATUE:int = 23;
		
		/** Request token has not been validated.*/
		public static const REQUEST_TOKEN_REQUIRED:int = 11;
		
		/** Token provided must be an access token. */
		public static const OAUTH_TOKEN_REQUIRED:int = 12;
		
		/** Token has expired. */
		public static const TOKEN_EXPIRED:int = 13;
		
		/** Authentication token can't be matched to a user. */
		public static const TOKEN_MISMATCH:int = 7;
		
		/** Token not found. */
		public static const TOKEN_NOT_FOUND:int = 16;
		
		/** Service not reachable, unable to get stored request token */
		public static const SECURITY_ERROR:int = 996;
		
		/** Service not reachable, unable to get stored request token */
		public static const CURRENT_USER_FAILED:int = 997;
		
		/** Unknown Error */
		public static const UNKNOWN_ERROR:int = 999;
		
		/** The requested service is temporarily unavailable. */
		public static const HTTP_REQUEST_ERROR:int = 404;
		
		/** Bad api request error made. **/
		public static const HTTP_BAD_REQUEST:int = 400;

		 
		public function YammerErrorTypes() {
			 throw Error("The YammerErrorTypes class cannot be instantiated.");
		}

	}
}
