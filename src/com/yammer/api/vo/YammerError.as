/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo
{
	import com.yammer.api.constants.YammerErrorTypes;

	public class YammerError
	{
		private var _errorCode:int;
		private var _errorMessage:String;
		private var _errorDetail:String;
		private var _errorEvent:Object;
		
		public function YammerError() 
		{
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
				case YammerErrorTypes.TOKEN_EXPIRED:
				case YammerErrorTypes.TOKEN_MISMATCH:
				case YammerErrorTypes.INVALID_LOGIN_ERROR:
				case YammerErrorTypes.TOKEN_NOT_FOUND:
				case YammerErrorTypes.UNKNOWN_TOKEN:
				case YammerErrorTypes.REQUEST_TOKEN_REQUIRED:
				case YammerErrorTypes.OAUTH_TOKEN_REQUIRED:
					return "Your current authorized token was not found, please reauthorize the application.";
					
				case YammerErrorTypes.GENERIC_DATABASE_ERROR:
					return "Unable to communicate to our database at this time. ";
					
				case YammerErrorTypes.INTERNAL_SERVER_ERROR_STATUS:
				case YammerErrorTypes.INTERNAL_SERVER_ERROR:
					return "Internal Server Error.";		
					
				case YammerErrorTypes.NO_NETWORK_CONNECTION:
				case YammerErrorTypes.NETWORK_CONNECTION_UNAVAILABLE:
					return "No netowrk connection to service."
					
				case YammerErrorTypes.UNAUTHORIZED_STATUS:
					return "Unauthorized. Invalid credentials."
					
				case YammerErrorTypes.UPLOAD_FILE_ERROR:
					return "Unable to upload your file. Please try again later.";
					
				case YammerErrorTypes.HTTP_REQUEST_ERROR:
					return "The server has not found a match for the requested URI."
					
				case YammerErrorTypes.HTTP_BAD_REQUEST:
					return "Bad Request."
					
				case YammerErrorTypes.INVALID_OAUTH_SIGNATUE:
				case YammerErrorTypes.UNSUPPORTED_SIGNATURE_METHOD:	
					return "The oauth request signature was not formed correctly."
				case YammerErrorTypes.FORBIDDEN_STATUS:
					return "Forbidden.  Access to service denied."
				case YammerErrorTypes.STREAM_ERROR:	
					return "The requested service is unreachable or there was an error with the request."
			}				
			
			return "An unknown error has occured.";
		}
	}
}