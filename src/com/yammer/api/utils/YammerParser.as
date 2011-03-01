/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.utils
{
	import com.yammer.api.vo.YammerCurrentUser;
	import com.yammer.api.vo.YammerGroup;
	import com.yammer.api.vo.YammerGroupRequest;
	import com.yammer.api.vo.YammerMessage;
	import com.yammer.api.vo.YammerMessageList;
	import com.yammer.api.vo.YammerNetwork;
	import com.yammer.api.vo.YammerNetworkCurrent;
	import com.yammer.api.vo.YammerSearch;
	import com.yammer.api.vo.YammerSubscription;
	import com.yammer.api.vo.YammerSuggestion;
	import com.yammer.api.vo.YammerTag;
	import com.yammer.api.constants.YammerTypes;
	import com.yammer.api.vo.YammerUser;
	

	public class YammerParser
	{	
		/**
		 * YammerParser will parse JSON objects
		 * */
		public function YammerParser()
		{ 
			throw Error("The YammerParser class cannot be instantiated.");
		}
		
		/**
		 * Parse networks JSON into a usable object. 
		 * @param object JSON data
		 * @return Array
		 * */
		public static  function parseNetworks(obj:Object):Array 
		{
			var networks:Array = new Array();
			var network:YammerNetwork = new YammerNetwork();
			
			for each (var net:Object in obj) {
				try {
					network = YammerFactory.network(net);
					networks.push(network);
				} catch (error:Error){
					trace("Exception parsing networks: " + "\nError: " + error.message);
				} 
			}
			
			return networks;     
		}   
		
		/**
		 * Parse current networks JSON into a usable object. 
		 * @param object JSON data
		 * @return Array
		 * */
		public static  function parseNetworkCounts(obj:Object):Array 
		{
			var networks:Array = new Array();
			var network:YammerNetworkCurrent = new YammerNetworkCurrent();
			
			for each (var net:Object in obj) {
				try {
					network = YammerFactory.networkCurrent(net);
					networks.push(network);
				} catch (error:Error){
					trace("Exception parsing current networks: " + "\nError: " + error.message);
				} 
			}
			
			return networks;     
		}     
		
		/**
		 * Parse current networks JSON into a usable object. 
		 * @param object JSON data
		 * @return Array
		 * */
		public static  function parseCurrentUser(obj:Object):YammerCurrentUser 
		{
			var user:YammerCurrentUser = YammerUserFactory.createCurrentUser(obj);
			
			// group memberships and subscriptions
			if(obj.group_memberships) user.group_memberships = parseGroups(obj.group_memberships as Array);
			
			// group memberships and subscriptions
			//if(obj.group_memberships) user.group_memberships = parseGroups(obj.group_memberships as Array);
			
			return user;     
		}  
		
		/**
		 * Parse current networks JSON into a usable object. 
		 * @param object JSON data
		 * @return Array
		 * */
		public static  function parseUser(obj:Object):YammerUser 
		{
			var user:YammerUser = YammerUserFactory.createUser(obj);
			return user;     
		}  

		/**
		 * Parse message list JSON into a usable object. 
		 * @param object JSON data
		 * @return YammerMessageList
		 * 
		 * TODO: references are only partial objects, we must be careful not to replace
		 * a full object with a reference.  Right now we accomplish this by parsing
		 * references first and then replacing them with actual message objects. 
		 * */
		public static function parseMessages(obj:Object):YammerMessageList 
		{
			var messageList:YammerMessageList = YammerFactory.messageList(obj);
			
			if(obj.references) cacheParsedObjects(obj.references, messageList);
			if(obj.messages) cacheParsedMessages(obj.messages, messageList);
			
			return messageList;
		}
		
		
		public static function parseSearch(obj:Object):YammerSearch
		{
			var searchResults:YammerSearch = new YammerSearch();
			
			var list:Array = [];
			
			// TODO: parse search result objects into CacheManager
			
			if(Number(obj.count.messages) > 0){	
				searchResults.count_messages = Number(obj.count.messages);
				searchResults.messages = parseMessageSearch(obj);
			} 
			
			if(Number(obj.count.groups) > 0){
				searchResults.count_groups = obj.count.groups;
				searchResults.groups = parseGroupSearch(obj);
			} 
			
			if(Number(obj.count.users) > 0) {
				searchResults.count_users = obj.count.users;
				searchResults.users = parseUserSearch(obj);
			} 
			
			if(Number(obj.count.tags) > 0) {
				searchResults.count_tags = obj.count.tags;
				searchResults.tags = parseTagSearch(obj);
			}
			
			return searchResults;
		}
	
		
		public static function parseMessageSearch(obj:Object):Array
		{
			var list:Array = obj.messages.messages as Array;
			var messages:Array = [];
			for each (var msg:Object in list) {
				var message:YammerMessage = YammerMessageFactory.createMessage(msg);
					messages.push(message);
			}

			return messages;
		}
		
		public static function parseUserSearch(obj:Object):Array 
		{	
			try{
				var arry:Array = parseUsers(obj.users as Array);
			} catch (error:Error){
				trace("Exception parsing message list user search: " + "\nError: " + error.message);
			} 
			return arry;
		}
		
		public static function parseGroupSearch(obj:Object):Array 
		{	
			try{
				var arry:Array = parseGroups(obj.groups as Array);
			} catch (error:Error){
				trace("Exception parsing message list group search: " + "\nError: " + error.message);
			} 
			return arry;
		}
		
		public static function parseTagSearch(obj:Object):Array 
		{	
			try{
				var arry:Array = parseTags(obj.tags as Array);
			} catch (error:Error){
				trace("Exception parsing message list tag search: " + "\nError: " + error.message);
			} 
			return arry;
		}
		
		/**
		 * Parses the user xml.
		 * */
		public static function parseUsers(userList:Array):Array 
		{
			var list:Array = new Array();
			
			for each (var obj:Object in userList) {
				try {
					var user:YammerUser = YammerFactory.user(obj);
					if (!user.id) { continue; }
					list.push(user);
				} catch (error:Error){
					trace("Exception parsing message list users: " + "\nError: " + error.message);
				} 
			}

			return list;			
		}

		public static  function parseTags(tagList:Array):Array 
		{
			var list:Array = new Array();

			for each (var obj:Object in tagList) {
				try {
					var tag:YammerTag = YammerFactory.tag(obj);
					if (!tag.id) { continue; }
					list.push(tag);
				} catch (error:Error){
					trace("Exception parsing message list tags: " + "\nError: " + error.message);
				} 
			}

			return list;     
		}		
		
		public static function parseGroup(obj:Object):YammerGroup
		{
			return YammerFactory.group(obj);
		}

		public static  function parseGroups(groupList:Array):Array 
		{
			var list:Array = new Array();
			for each (var obj:Object in groupList) {
				try {
					var group:YammerGroup = YammerFactory.group(obj);
					if (!group.id) { continue; }
					list.push(group);
				} catch (error:Error){
					trace("Exception parsing message list groups: " + "\nError: " + error.message);
				} 
			}

			return list;     
		}   

		public static function parseSuggestions(suggestions:Object):Array 
		{
			var list:Array = new Array();
		
			try {
				for each (var suggestion:Object in suggestions) { 
					list.push( parseSuggestion( suggestion ) ); 
				}
			
			} catch (error:Error){
				trace("Exception parsing message list suggestions: " + "\nError: " + error.message);
			} 
				
			return list;
		}  

		private static function parseSuggestion(obj:Object):YammerSuggestion 
		{
			var type:String = obj.suggested.type
			var id:Number = obj.id;
			var suggestion:YammerSuggestion = new  YammerSuggestion();
			try{
				switch (type) { 
					case YammerTypes.USER_TYPE:
							suggestion.id = id;
							suggestion.type = YammerTypes.USER_TYPE;
							suggestion.user = YammerFactory.user(obj.suggested);
						return suggestion;
						break;
					case YammerTypes.GROUP_TYPE:
							suggestion.id = id;
							suggestion.type = YammerTypes.GROUP_TYPE;
							suggestion.group = YammerFactory.group(obj.suggested);
						return suggestion;
						break;    
				}    
			
			} catch (error:Error){
				trace("Exception parsing message list suggestions: " + "\nError: " + error.message);
			} 
			return null;  	
		}
		
		/**
		 * Parses the requests to join groups into value objects.
		 * @param obj JSON data
		 * @return Array of <code>YammerRelationship</code> value objects
		 * */
		public static function parseRequests(obj:Object):Array 
		{
			var list:Array = new Array();
			
			try{
				
				YammerParser.cacheParsedObjects(obj.references as Array);
	
				var group_requests:Array = obj.group_invitations; // request for you to join a group
				var join_requests:Array = obj.group_requests as Array; // request to join your group
		
				for each (var group:Object in group_requests) {
					var groupRequest:YammerGroupRequest = YammerFactory.groupRequests(group);
					list.push(groupRequest);
				}
	
				for each (var join:Object in join_requests) {
					var joinRequest:YammerGroupRequest = YammerFactory.joinRequests(join);
					list.push(joinRequest);
				}
			
			} catch (error:Error){
				trace("Error: Exception parsing message list requests: " + "\nError: " + error.message);
			} 
			
			return list;   
		}
		
		private static function cacheParsedMessages(list:Object, messageList:YammerMessageList = null):void
		{	
			var obj:Object;

			for each (obj in list) {
				CacheManager.instance.addMessage(YammerMessageFactory.createMessage(obj, messageList));
			}
			
			obj = null;
			list = null;
		}
		
		private static function cacheParsedObjects(list:Object, messageList:YammerMessageList = null):void
		{	
			var obj:Object;

			for each (obj in list) {
				
				if (obj.type == YammerTypes.MESSAGE_TYPE){
					CacheManager.instance.addMessage(YammerMessageFactory.createMessage(obj, messageList));
				} else if(obj.type == YammerTypes.USER_TYPE){
					CacheManager.instance.addUser(YammerUserFactory.createUser(obj));	
				} else if (obj.type == YammerTypes.BOT_TYPE){
					CacheManager.instance.addBot(YammerUserFactory.createUser(obj))
				} else if (obj.type == YammerTypes.GROUP_TYPE){
					CacheManager.instance.addGroup(YammerFactory.group(obj))
				} else if (obj.type == YammerTypes.THREAD_TYPE){
					CacheManager.instance.addThread(YammerFactory.thread(obj));
				} else if (obj.type == YammerTypes.TAG_TYPE){
					CacheManager.instance.addTag(YammerFactory.tag(obj));
				} 
			}
			
			obj = null;
			list = null;
		}
	}
}
