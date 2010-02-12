/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.utils
{
	import com.yammer.api.vo.YammerAttachment;
	import com.yammer.api.constants.YammerAttachmentTypes;
	import com.yammer.api.vo.YammerGroup;
	import com.yammer.api.vo.YammerGroupRequest;
	import com.yammer.api.constants.YammerGroupTypes;
	import com.yammer.api.vo.YammerMessageList;
	import com.yammer.api.vo.YammerNetwork;
	import com.yammer.api.vo.YammerNetworkCurrent;
	import com.yammer.api.vo.YammerSubscription;
	import com.yammer.api.vo.YammerTab;
	import com.yammer.api.vo.YammerTag;
	import com.yammer.api.vo.YammerThread;
	import com.yammer.api.constants.YammerTypes;
	import com.yammer.api.vo.YammerUser;
	
	import flash.utils.Dictionary;
 
	public class YammerFactory 
	{
		public function YammerFactory()
		{
			throw Error("The YammerFactory class cannot be instantiated.");
		}
		
		public static function network(obj:Object):YammerNetwork 
		{
			var network:YammerNetwork = new YammerNetwork();
			
			try{
				network.user_id = obj.user_id;
				network.secret = obj.secret;
				network.token = obj.token;
				network.network_name = obj.network_name;
				network.network_id = obj.network_id;
				network.network_permalink = obj.network_permalink;
				obj = null;
			} catch (error:Error){
				throw new Error("Exception parsing network: " + "\nError: " + error.message);
			} 
			
			return network;
		}
		
		public static function networkCurrent(obj:Object):YammerNetworkCurrent 
		{
			var network:YammerNetworkCurrent = new YammerNetworkCurrent();
			
			try{
				network.id = obj.id
				network.permalink = obj.permalink
				network.name = obj.name
				network.unseen_messsage_count = Number(obj.unseen_message_count);
				obj = null;
			} catch (error:Error){
				throw new Error("Exception parsing networks current : " + "\nError: " + error.message);
			} 
			
			return network;
		}
		
		
		/**
		 * Great <code>YammerMessageList</code>.
		 * 
		 * @public obj JSON object
		 * @return <code>YammerMessageList</code>
		 * */
		public static function messageList(obj:Object):YammerMessageList 
		{
			var messageList:YammerMessageList = new YammerMessageList();
			
			try{
				messageList.current_user_id = obj.meta.current_user_id;
				
				if(obj.meta){
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
				
				if(obj.messages) {
					var msgs:Array = new Array();
					for each (var msg:Object in obj.messages){
						msgs.push(msg.id);
					}
					messageList.messages = msgs;
				}	
			} catch (error:Error){
				throw new Error("Exception parsing messagelist: " + "\nError: " + error.message);
			} 
			return messageList;
		}
		
		public static function user(obj:Object):YammerUser 
		{
			var user:YammerUser = YammerUserFactory.createUser(obj);
			return user;
		}
		
		/**
		 * Great <code>YammerGroup</code> from user object.
		 * 
		 * @public obj JSON object
		 * @return <code>YammerGroup</code>
		 * */
		public static function group(obj:Object):YammerGroup 
		{
			var group:YammerGroup = new YammerGroup();
			try{
				group.id = obj.id;
				group.type = obj.type;
				group.name = obj.name;
				group.full_name = obj.full_name;
				group.mugshot_url = obj.mugshot_url;
				group.url = obj.url;
				group.web_url = obj.web_url;
				group.description = obj.description;
				group.privacy = obj.privacy;
				
				if(obj.stats) {
					group.members = obj.stats.members;
					group.updates = obj.stats.updates;
				}
				obj = null;
			} catch (error:Error){
				throw new Error("Exception parsing group: " + "\nError: " + error.message);
			} 
			return group;
		}
		
		public static function thread(obj:Object):YammerThread 
		{
			var thread:YammerThread = new YammerThread();
			try {
				thread.id = obj.id; 
				thread.body = obj.body; 
				thread.web_url = obj.web_url;
				obj = null;
				
			} catch (error:Error){
				throw new Error("Exception parsing thread: " + "\nError: " + error.message);
			}
			return thread;
		}
		
		public static function tag(obj:Object):YammerTag 
		{
			var tag:YammerTag = new YammerTag();
			try {
				tag.name = obj.name;
				tag.id = obj.id;
				tag.type = YammerTypes.TAG_TYPE;
				tag.url = obj.web_url;
				tag.data_url = obj.url;
				tag.followers = obj.followers;
				obj = null;
			} catch (error:Error){
				throw new Error("Exception parsing tag: " + "\nError: " + error.message);
			}
			return tag;
		}
		
		public static function tab(obj:Object):YammerTab 
		{ 
			var tab:YammerTab = new YammerTab();
			try {
				tab.type = obj.type
				tab.name = obj.name
				tab.url = obj.url
				tab.ordering_index = obj.ordering_index;
				tab.select_name = obj.select_name;
				tab.group_id = obj.group_id;
				tab.is_private = (obj.private == "true");
				tab.feed_description = obj.feed_description;
				obj = null;
			}



 catch (error:Error){
				throw new Error("Exception parsing tab: " + "\nError: " + error.message);
			}
			return tab;
		}
		
		public static function subscription(obj:Object):YammerSubscription 
		{
			var subscription:YammerSubscription = new YammerSubscription();
			try {
				subscription.id = obj.id;
				subscription.name = obj.name;
				subscription.web_url = obj.web_url;
				subscription.job_title = obj.job_title
				subscription.mugshot_url = obj.mugshot_url;
				subscription.url = obj.url;
				subscription.type = obj.type;
				subscription.full_name = obj.full_name;
				
				if(obj.stats){
					subscription.followers = obj.stats.followers;
					subscription.following = obj.stats.following;
					subscription.updates = obj.stats.updates;
				}
				obj = null;
			} catch (error:Error){
				throw new Error("Exception parsing subscription: " + "\nError: " + error.message);
			}
			return subscription;
		}

		public static function attachment(obj:Object):YammerAttachment 
		{
			var attachment:YammerAttachment = new YammerAttachment ();
			try {
					attachment.id = obj.id
					attachment.type = obj.type;
					attachment.name = obj.name;
					attachment.size= obj.size;
					attachment.web_url = obj.web_url;
	
				if (attachment.type == YammerAttachmentTypes.IMAGE_TYPE) {
					attachment.thumbnail_url = obj.image.thumbnail_url;
					attachment.url = obj.image.url;
				} else if (attachment.type == YammerAttachmentTypes.FILE_TYPE) {
					attachment.url = obj.file.url;
				}
				obj = null;
			} catch (error:Error){
				throw new Error("Exception parsing attachment: " + "\nError: " + error.message);
			}
			
			return attachment;
		}
		
		public static function groupRequests(obj:Object):YammerGroupRequest 
		{
			var request:YammerGroupRequest = new YammerGroupRequest();
			try{
				request.type = YammerGroupRequest.GROUP_REQUEST;
				request.url = obj.url;
				request.web_url = obj.web_url;
				request.created = new Date(String(obj.created_at));
				request.group_id = obj.group_id;
				request.inviter_ids = obj.inviter_ids as Array;
			} catch (error:Error){
				throw new Error("Exception parsing group request: " + "\nError: " + error.message);
			}
			
			return request;
		}

		public static function joinRequests(obj:Object):YammerGroupRequest 
		{
			var request:YammerGroupRequest = new YammerGroupRequest();
			try{
				request.type = YammerGroupRequest.JOIN_REQUEST;
				request.group_id = obj.group_id;
				request.user_id = obj.user_id;
	   			
	   			obj = null;
	
			} catch (error:Error){
				throw new Error("Exception parsing join request: " + "\nError: " + error.message);
			}
			return request;			
		}

		
	}
}
