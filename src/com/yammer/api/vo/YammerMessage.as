/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	/**
	 * YammerMessage is a value object service message types.
	 * */
	 [Bindable]
	public class YammerMessage
	{
		public var id:String;
		public var type:String = YammerTypes.MESSAGE_TYPE;
		public var web_url:String;
		public var url:String;
		public var message_type:String = YammerMessageTypes.UPDATE;
		
		public var body_plain:String;
		public var body_parsed:String;
		
		public var created_at:Date = new Date();
	
		public var sender_id:String;
		public var sender_type:String;  // YammerSenderTypes
		
		public var client_url:String;
		public var client_type:String;
		
		public var thread_id:String; 
	
		public var group_id:String;
		public var group:YammerGroup // Yammer group from references
		
		public var reply_to_id:String;
		public var direct_to_id:String;
		
		public var liked_by_names:Array = new Array(); // list of liked by name objects
		public var liked_by_count:Number = 0; // the number of people who liked this message
		
		public var attachments:Array = new Array();
		public var system_message:Boolean = false;
		
		// variables added to process and store extra data about messages
		
		public var is_liked:Boolean = false; // message is favorite message
		public var is_favorite:Boolean = false; // message is favorite message
		public var display_time:String; // store formatted local time
		public var truncate:Boolean = true; // message is truncated in size (add expand/collaps option)
		
		public var references:Array = new Array(); // keep track of references refered to in the message (tags, groups, users);
		public var sender:YammerUser; // the sender of the message from references
		public var recipient:YammerUser; // the recipient of a direct or reply message from references
		public var recipient_message:YammerMessage; // the reply to message from references

		public function YammerMessage() 
		{		
		}
	}
}
