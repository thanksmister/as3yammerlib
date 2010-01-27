/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.events
{
	import com.yammer.api.YammerError;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * This event is fired when a results are returned from service calls.
	 * @author Michael Ritchie
	 */ 
	public class YammerEvent extends Event
	{
		// General request events
		public static const REQUEST_COMPLETE:String = "requestComplete";
		public static const REQUEST_FAIL:String = "requestFail";
		
		// Standard events
		public static const HTTP_STATUS:String = "httpStatus";
		public static const IO_WARNING:String = "ioWarning";
		public static const IO_ERROR:String = "ioError";
		public static const PROGRESS:String = "progress";
		public static const SECURITY_ERROR:String = "securityError";
		
		// Oauth evetns
		public static const REQUEST_TOKEN:String = "requestToken";
		public static const ACCESS_TOKEN:String = "accessToken";
		
		// Additional service events
		public static const CURRENT_USER:String = "currentUser";
		public static const NETWORKS_REQUEST:String = "networksRequest";
		public static const NETWORKS_CURRENT_REQUEST:String = "networksCurrentRequest";
		
		public static const MESSAGES_REQUEST_RESULTS:String = "messagesRequestResults";
	
		public static const GROUP_REQUEST_RESULTS:String = "groupRequestResults";
		public static const USER_REQUEST_RESULTS:String = "userRequestResults";
		public static const TAG_REQUEST_RESULTS:String = "tagRequestResults";
		public static const RSS_REQUEST_RESULTS:String = "rssRequestResults";
		public static const SEARCH_REQUEST_RESULTS:String = "searchRequestResults";
		public static const AUTO_COMPLETE_RESULTS:String = "autoCompleteResults";
		public static const SUGGESTIONS_RESULTS:String = "suggestionsResults";
		public static const REQUESTS_RESULTS:String = "requestsResult";
		
		private var _data : Object;
		private var _error:YammerError;
		private var _bytes:ByteArray;
		
		/**
		 * Data object.
		 * @return
		 *
		 */ 
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * Progress bytes.
		 * @return
		 *
		 */ 
		public function get bytes():ByteArray
		{
			return _bytes;
		}
		
		/**
		 * Error object.
		 * @return
		 *
		 */ 
		public function get error():YammerError
		{
			return _error;
		}
		
		/**
		 * YammerEvent Constructor
		 * @param type String
		 * @param data Object
		 * @param bytes ByteArray
		 * @param error YammerError
		 * @param bubbles Boolean
		 * @param cancelable Boolean
		 */  
		public function YammerEvent (type : String, data : Object = null, bytes : ByteArray = null, error : YammerError = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super (type, bubbles, cancelable);
			
			_data = data;
			_bytes = bytes;
			_error = error;
		}
		
		/**
		 * Returns new YammerEvent.
		 * @return
		 *
		 */
		override public function clone():Event
		{
			return new YammerEvent(type, data, bytes, error, bubbles, cancelable);
		}
	}
}
