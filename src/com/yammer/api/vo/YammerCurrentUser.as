/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerPaths;
	import com.yammer.api.constants.YammerTabTypes;
	
	public class YammerCurrentUser extends YammerUser
	{	
		public var tabs:Array;
		public var subscriptions:Array;
		public var group_memberships:Array;
		
		public var user_subscription_ids:Array;
		public var tag_subscription_ids:Array;
		public var group_membership_ids:Array;
		
		public var enter_does_not_submit_messages:Boolean = false;
		public var absolute_timestmaps:Boolean = false;
		public var show_full_names:Boolean = true;
		public var allow_attachments:Boolean = true;
		public var message_prompt:String;
		
		public function YammerCurrentUser()
		{
		}

		
		public function getYammerSubscription():YammerSubscription
		{
			var subscription:YammerSubscription = new YammerSubscription();
				subscription.id = this.id;
				subscription.type = this.type;
				subscription.full_name = this.full_name;
				subscription.name = this.name;
				subscription.mugshot_url = this.mugshot_url;
				subscription.job_title = this.job_title;
				subscription.url = this.url;
				subscription.web_url = this.web_url;
			return subscription;
		}

		/**
		 * Returns true if user or tag id is listed in the current users
		 * subscription list. (meaning current user is following the tag or user).
		 * @public
		 * @param id <code>YammerUser</code> or <code>YammerTag</code> id
		 * @param type <code>YammerType</code>
		 * */
		public function isFollowing(id:String, type:String):Boolean 
		{	
			var following:Boolean = false;
			for each (var sub:YammerSubscription in subscriptions){
				if(sub.type == type){
					if(id == sub.id){
						following = true;
						break;
					}  
				}
			}
			return  following;
		}
		
		/**
		 * Returns true if group id is listed in the current users
		 * group list. (meaning current user has already joined group).
		 * @public
		 * @param id <code>YammerGroup</code> id
		 * */
		public function hasJoinedGroup(id:String):Boolean 
		{	
			var joined:Boolean = false;
			for each (var group:YammerGroup in this.group_memberships){
				if(group.id == group.id){
					joined = true;
					break;
				}  
			}
			return  joined;
		}

		
		/**
		 * Adds a new subscription to the user's subscription list.
		 * @public
		 * @param Object
		 * */
		public function addSubscription(subscription:YammerSubscription):void 
		{	
			subscriptions.push(subscription);
		}
		
		/**
		 * Remove a subscription to the user's subscription list.
		 * @public
		 * @param Object
		 * */
		public function removeSubscription(subscription:YammerSubscription):void 
		{	
			var index:int = subscriptions.indexOf(subscription);
			if(index >= 0) subscriptions = subscriptions.slice(index, index + 1);
		}
		
		/**
		 * Adds a new group to the users group list.
		 * @public
		 * @param group <code>YammerGroup</code> 
		 * */
		public function addGroup(group:YammerGroup):void 
		{	
			group_memberships.push(group);
		}
		
		/**
		 * Remove a group from the users group list.
		 * @public
		 * @param group <code>YammerGroup</code> 
		 * */
		public function removeGroup(group:YammerGroup):void 
		{	
			var index:int = group_memberships.indexOf(group);
			if(index >= 0) group_memberships = group_memberships.slice(index, index + 1);
		}
		
		/**
		 * Only the current account user will have contact information available.
		 * this check could be used to determine if user is current user or not.
		 * */
		public function get hasContactInformation():Boolean 
		{
			return ((email_addresses && email_addresses.length >0) || (im && im.length >0) || (phone_numbers && phone_numbers.length >0))
		}
		
		/**
		 * Returns a list of main home tabs (no groups)
		 * 
		 * @param tabList List of home tabs for current user
		 * @return Array list of main tabs for current user
		 * */
		public static function mainTabs(tabList:Array):Array
		{	
			var temp:Array = new Array();
			for each (var tab:YammerTab in tabList){
				if(tab.type != YammerTabTypes.TAB_GROUP){
					temp.push(tab);
				}
			}
			
			return temp;
		}
		
		/**
		 * Returns a list of group home tabs (no groups)
		 * 
		 * @param tabList List of home tabs for current user
		 * @return Array list of group tabs for current user
		 * */
		public static function groupTabs(tabList:Array):Array
		{	
			var temp:Array = new Array();
			for each (var tab:YammerTab in tabList){
				if(tab.type == YammerTabTypes.TAB_GROUP){
					temp.push(tab);
				}
			}
			
			return temp;
		}
		
		/**
		 * This is kind of a work around for a bug where some images don't have http or https.
		 * @private
		 * */
		private function validateLink(s:String):String 
		{
			var pattern:RegExp=/http(?:s?)\:\/\//; 
			
			var t:Array = s.match(pattern);
			
			if(!t) {
				var badpattern:RegExp=/ttp(?:s?)\:\/\//
				var b:Array = s.match(badpattern);
				if(b) {
					s = "h" + s;
					trace("YammerUser :: invalid mug shot: " + b) ;
					return s;
				}
			}
			
			return (!t) ? YammerPaths.BASE_URL  + s : s; 
		}

	}
}
