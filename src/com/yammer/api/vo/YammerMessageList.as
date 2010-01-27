/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo
{
	import flash.utils.Dictionary;
	
	public class YammerMessageList
	{
		public var references:Dictionary = new Dictionary();  // dictionary to look up references by key
		public var messages:Array;
		public var followed_user_ids:Array;
		public var liked_message_ids:Array;
		public var favorite_message_ids:Array;

		public var threaded_extended:Boolean = false;
		public var show_billing_banner:Boolean = false;
		
		public var current_user_id:String;
		public var last_seen_message_id:String;
		public var older_available:Boolean = false;
		public var requested_poll_interval:Number = 60; // default polling number
		public var unseen_message_count_following:Number;
		public var unseen_message_count_received:Number;
		
		public function YammerMessageList()
		{
		}
	}
}
