/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.utils
{
	import com.yammer.api.vo.YammerGroup;
	import com.yammer.api.vo.YammerMessage;
	import com.yammer.api.vo.YammerTag;
	import com.yammer.api.vo.YammerThread;
	import com.yammer.api.vo.YammerUser;
	
	import flash.utils.Dictionary;
	
	public final class CacheManager
	{
		private static var _instance:CacheManager = new CacheManager();
		
		private var messages:Dictionary = new Dictionary(true);  
		private var users:Dictionary = new Dictionary(true);  
		private var groups:Dictionary = new Dictionary(true);  
		private var threads:Dictionary = new Dictionary(true); 
		private var tags:Dictionary = new Dictionary(true); 
		private var bots:Dictionary = new Dictionary(true); 
		
		public function CacheManager()
		{
			if (_instance != null) {
				throw new Error("CacheManager can only be accessed through CacheManager.instance");
			}
		}
		
		public static function get instance():CacheManager
		{
			return _instance;
		}
		
		public function flushCache():void
		{
			messages = new Dictionary(true);  
			users = new Dictionary(true);  
			groups = new Dictionary(true);  
			threads = new Dictionary(true); 
			tags = new Dictionary(true); 
			bots = new Dictionary(true); 
		}
		
		public function getUser(id:String):YammerUser
		{
			return users[id] as YammerUser;
		}
		
		public function getGroup(id:String):YammerGroup
		{
			return groups[id] as YammerGroup;
		}
		
		public function getMessage(id:String):YammerMessage
		{
			return messages[id] as YammerMessage;
		}
		
		public function getThread(id:String):YammerThread
		{
			return threads[id] as YammerThread;
		}
		
		public function getTag(id:String):YammerTag
		{
			return tags[id] as YammerTag;
		}
		
		public function getBot(id:String):YammerUser
		{
			return bots[id] as YammerUser;
		}
		
		public function addMessage(value:YammerMessage):void
		{
			messages[value.id] = value;
		}
		
		public function addUser(value:YammerUser):void
		{
			users[value.id] = value;
		}
		
		public function addGroup(value:YammerGroup):void
		{
			groups[value.id] = value;
		}
		
		public function addThread(value:YammerThread):void
		{
			threads[value.id] = value;
		}
		
		public function addTag(value:YammerTag):void
		{
			tags[value.id] = value;
		}
		
		public function addBot(value:YammerUser):void
		{
			bots[value.id] = value;
		}
		
		public function removeMessage(value:YammerMessage):void
		{
			messages[value.id] = null;
		}
		
		public function removeUser(value:YammerUser):void
		{
			users[value.id] = null;
		}
		
		public function removeGroup(value:YammerGroup):void
		{
			groups[value.id] = null;
		}
		
		public function removeThread(value:YammerThread):void
		{
			threads[value.id] = null;
		}
		
		public function removeTag(value:YammerTag):void
		{
			tags[value.id] = null;
		}
		
		public function removeBot(value:YammerUser):void
		{
			bots[value.id] = null;
		}
		
		public function removeMessages():void
		{
			messages = new Dictionary(true);
		}
		
		public function removeUsers():void
		{
			users = new Dictionary(true);
		}
		
		public function removeGroups():void
		{
			groups = new Dictionary(true);
		}
		
		public function removeThreads():void
		{
			threads = new Dictionary(true);
		}
		
		public function removeTags():void
		{
			tags = new Dictionary(true);
		}
		
		public function removeBots():void
		{
			bots = new Dictionary(true);
		}
	}
}