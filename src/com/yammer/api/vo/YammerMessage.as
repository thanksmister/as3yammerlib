/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerMessageTypes;
	import com.yammer.api.constants.YammerTypes;
	import com.yammer.api.utils.CacheManager;

	public class YammerMessage
	{
		public var id:String;
		public var type:String = YammerTypes.MESSAGE_TYPE; // added because other objects have types
		public var message_type:String = YammerMessageTypes.UPDATE;
		public var web_url:String;
		public var url:String;
		public var body_plain:String;
		public var body_parsed:String;
		public var created_at:Date = new Date();
		public var sender_id:String;
		public var sender_type:String;  // YammerSenderTypes
		public var client_url:String;
		public var client_type:String;
		public var thread_id:String; 
		public var group_id:String;
		public var reply_to_id:String;
		public var direct_to_id:String;
		public var liked_by_names:Array = new Array(); // list of liked by name objects
		public var liked_by_count:Number = 0; // the number of people who liked this message
		public var system_message:Boolean = false; // broadcast message should be formatted differently
		public var attachments:Array = new Array();
		
		// convenience paramaters to help display messages parts
		public var is_liked:Boolean = false; // message is liked message
		public var is_favorite:Boolean = false; // message is favorite
		public var display_time:String; // store formatted local time
		public var truncate:Boolean = true; // message is truncated in size (add expand/collaps option)

		public function YammerMessage() 
		{		
		}
		
		public function get sender():YammerUser
		{
			if(this.sender_type == YammerTypes.USER_TYPE) {
				return CacheManager.instance.getUser(this.sender_id);
			} else if (this.sender_type == YammerTypes.BOT_TYPE) {
				return CacheManager.instance.getBot(this.sender_id);
			}
			
			return null;
		}
		
		public function get recipient():YammerUser
		{
			if(this.direct_to_id) return this.direct_recipient;
			
			var message:YammerMessage = this.recipient_message;
			var user:YammerUser = CacheManager.instance.getUser(message.sender_id);
			if(!user) user = CacheManager.instance.getBot(message.sender_id);
			
			return user;
		}
		
		public function get direct_recipient():YammerUser
		{
			return CacheManager.instance.getUser(this.direct_to_id);
		}
		
		public function get recipient_message():YammerMessage
		{
			return CacheManager.instance.getMessage(this.reply_to_id);
		}
		
		public function get thread():YammerThread
		{
			return CacheManager.instance.getThread(this.thread_id);
		}
		
		public function get group():YammerGroup
		{
			return CacheManager.instance.getGroup(this.group_id);
		}
		
		public function get bot():YammerUser
		{
			return CacheManager.instance.getBot(this.sender_id);
		}
		
		public function getReferencedUser(id:String):YammerUser
		{
			return CacheManager.instance.getUser(id);
		}
		
		public function getReferencesGroup(id:String):YammerGroup
		{
			return CacheManager.instance.getGroup(id);
		}
		
		public function getReferencedTag(id:String):YammerTag
		{
			return CacheManager.instance.getTag(id);
		}
		
		public function getReferencedBot(id:String):YammerUser
		{
			return CacheManager.instance.getBot(id);
		}
		
		public function hasRecipient():Boolean
		{
			if(this.reply_to_id) return true;
			return false;
		}
		
		public function isDirectMessage():Boolean
		{
			if(this.direct_to_id) return true;
			return false;
		}
	}
}
