/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.utils
{
	import com.yammer.api.vo.YammerGroup;
	import com.yammer.api.vo.YammerGroupRequest;
	import com.yammer.api.vo.YammerMessage;
	import com.yammer.api.vo.YammerMessageList;
	import com.yammer.api.vo.YammerNetwork;
	import com.yammer.api.vo.YammerNetworkCurrent;
	import com.yammer.api.vo.YammerSearch;
	import com.yammer.api.vo.YammerSuggestion;
	import com.yammer.api.vo.YammerTag;
	import com.yammer.api.vo.YammerTypes;
	import com.yammer.api.vo.YammerUser;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class YammerParser extends EventDispatcher	
	{	
		/**
		 * YammerParser will parse JSON objects
		 * */
		public function YammerParser()
		{ 
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
			var list:Array = obj.response as Array;
			
			for each (var obj:Object in list) {
				try {
					network = YammerFactory.network(obj);
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
		public static  function parseCurrentNetworks(obj:Object):Array 
		{
			var networks:Array = new Array();
			var network:YammerNetworkCurrent = new YammerNetworkCurrent();
			var list:Array = obj.response as Array;
			
			for each (var obj:Object in list) {
				try {
					network = YammerFactory.networkCurrent(obj);
					networks.push(network);
				} catch (error:Error){
					trace("Exception parsing current networks: " + "\nError: " + error.message);
				} 
			}
			
			return networks;     
		}     

		/**
		 * Parse message JSON into a usable object. 
		 * @param object JSON data
		 * @return YammerMessageList
		 * */
		public static function parseMessages(obj:Object):YammerMessageList 
		{
			var messageList:YammerMessageList = new YammerMessageList();
			
			try{
				messageList.current_user_id = obj.meta.current_user_id;
				
				if(obj.mesta){
					messageList.unseen_message_count_following = Number(obj.meta.unseen_message_count_following);
					messageList.unseen_message_count_received = Number(obj.meta.unseen_message_count_received);
					messageList.last_seen_message_id = obj.meta.last_seen_message_id;
					messageList.requested_poll_interval = Number(obj.meta.requested_poll_interval);
					messageList.older_available = (obj.meta.older_available == 'true') ? true : false;
					messageList.show_billing_banner = (obj.meta.show_billing_banner == 'true') ? true : false;
					
					messageList.favorite_message_ids = obj.meta.favorite_message_ids as Array; // list of favorite
					messageList.liked_message_ids = obj.meta.liked_message_ids as Array; // list of liked messages
					messageList.followed_user_ids = obj.meta.followed_user_ids as Array;
				}				
				
				if(obj.references) messageList.references = YammerMessageFactory.createReferences(obj.references as Array, messageList.followed_user_ids, messageList.liked_message_ids, messageList.favorite_message_ids);
				if(obj.messages) messageList.messages = YammerMessageFactory.createMessages(obj.messages as Array, messageList.references, messageList.followed_user_ids, messageList.liked_message_ids, messageList.favorite_message_ids);

			} catch (error:Error){
				trace("Exception parsing message list: " + "\nError: " + error.message);
			} 
			
			return messageList;
		}
		
		public static function parseSearch(obj:Object):YammerSearch
		{
			var searchResults:YammerSearch = new YammerSearch();
			
			var list:Array = [];
	
			if(Number(obj.count.messages) > 0){	
				searchResults.count_messages = Number(obj.count.messages);
				searchResults.references = parseReferencesSearch(obj);
				searchResults.messages = parseMessageSearch(obj, searchResults.references);
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
		
		public static function parseReferencesSearch(obj:Object):Dictionary
		{
			var references:Dictionary = YammerMessageFactory.createReferences(obj.messages.references as Array);
			return references;
		}
		
		public static function parseMessageSearch(obj:Object, references:Dictionary):Array
		{
			var list:Array = obj.messages.messages as Array;
			var messages:Array = [];
			for each (var msg:Object in list) {
				var message:YammerMessage = YammerMessageFactory.createMessage(msg, references);
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
		 * Parses the requests to joing groups into value objects.
		 * @param obj JSON data
		 * @return Array of <code>YammerRelationship</code> value objects
		 * */
		public static function parseRequests(obj:Object):Array 
		{
			var list:Array = new Array();
			
			try{
				var references:Dictionary =  YammerMessageFactory.createReferences(obj.references as Array);
	
				var group_requests:Array = obj.group_invitations; // request for you to join a group
				var join_requests:Array = obj.group_requests as Array; // request to join your group
		
				for each (var group:Object in group_requests) {
					var groupRequest:YammerGroupRequest = YammerFactory.groupRequests(group, references);
					list.push(groupRequest);
				}
	
				for each (var join:Object in join_requests) {
					var joinRequest:YammerGroupRequest = YammerFactory.joinRequests(join, references);
					list.push(joinRequest);
				}
			
			} catch (error:Error){
				trace("Exception parsing message list requests: " + "\nError: " + error.message);
			} 
			
			return list;   
		}
	}
}
