/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api
{
	/**
	 * The YammerError class handles errors from Yammer API.
	 * 
	 * YammerError is the helper class for mapping error codes to more generic and user-friendly
	 * error messages.  
	 */
	public class YammerError
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

	
		private var _errorCode:int;
		private var _errorMessage:String;
		private var _errorDetail:String;
		private var _errorEvent:Object;
		
		public function YammerError() 
		{
		}
		
		/**
		 * Returns error message by errror number.
		 * 
		 * @param errorCode The number of the error code.
		 * @return String The error message.
		 **/
		public static function getErrorMessage(errorCode : Number) : String
		{
			//trace("YammerError :: getErrorMessage error code: " + errorCode);
			
			switch (errorCode)
			{
				case YammerError.TOKEN_EXPIRED:
				case YammerError.TOKEN_MISMATCH:
				case YammerError.INVALID_LOGIN_ERROR:
				case YammerError.TOKEN_NOT_FOUND:
				case YammerError.UNKNOWN_TOKEN:
				case YammerError.REQUEST_TOKEN_REQUIRED:
				case YammerError.OAUTH_TOKEN_REQUIRED:
					return "Your current authorized token was not found, please reauthorize the application.";
				
				case YammerError.GENERIC_DATABASE_ERROR:
					return "Unable to communicate to our database at this time. ";
				
				case YammerError.INTERNAL_SERVER_ERROR_STATUS:
				case YammerError.INTERNAL_SERVER_ERROR:
					return "Internal Server Error.";		
					
				case YammerError.NO_NETWORK_CONNECTION:
				case YammerError.NETWORK_CONNECTION_UNAVAILABLE:
					return "No netowrk connection to service."
					
				case YammerError.UNAUTHORIZED_STATUS:
					return "Unauthorized. Invalid credentials."
		
				case YammerError.UPLOAD_FILE_ERROR:
					return "Unable to upload your file. Please try again later.";
				
				case YammerError.HTTP_REQUEST_ERROR:
					return "The server has not found a match for the requested URI."
				
				case YammerError.HTTP_BAD_REQUEST:
					return "Bad Request."
		
				case YammerError.INVALID_OAUTH_SIGNATUE:
				case YammerError.UNSUPPORTED_SIGNATURE_METHOD:	
					return "The oauth request signature was not formed correctly."
				case YammerError.FORBIDDEN_STATUS:
					return "Forbidden.  Access to service denied."
				case YammerError.STREAM_ERROR:	
					return "The requested service is unreachable or there was an error with the request."
			}				

			return "An unknown error has occured.";
		}
		
		public function get errorCode():int 
		{
			return _errorCode;	
		}
		
		public function set errorCode( value:int ):void 
		{
			_errorCode = value;	
		}
		
		public function get errorMessage():String 
		{
			return _errorMessage;	
		}
		
		public function set errorMessage( value:String ):void 
		{
			_errorMessage = value;	
		}
		
		public function get errorDetail():String 
		{
			return _errorDetail;	
		}
		
		public function set errorDetail( value:String ):void 
		{
			_errorDetail = value;	
		}
		
		public function get erroEvent():Object 
		{
			return _errorEvent;	
		}
		
		public function set erroEvent( value:Object ):void 
		{
			_errorEvent = value;	
		}
		
	}
}