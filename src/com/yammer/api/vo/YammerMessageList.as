/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo
{
	import com.yammer.api.utils.CacheManager;

	public class YammerMessageList
	{
		public var id:String;  // the unique feed id, which is the url or id 
		public var type:String; // feed type
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
		
		public var messages:Array; // array of msg id's referenced by messagelist
		
		public function YammerMessageList()
		{
		}
		
		public function getMessage(id:String):YammerMessage
		{
			return CacheManager.instance.getMessage(id);
		}
		
		public function getMessages():Array
		{
			var list:Array = new Array();
			
			for each (var id:String in messages) {
	
				list.push(CacheManager.instance.getMessage(id));
			}
			
			return list;
		}
	}
}
