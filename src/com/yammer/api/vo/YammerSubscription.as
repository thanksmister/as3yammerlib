/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerPaths;
	
	public class YammerSubscription
	{
		public var id:String;
		public var type:String;
		public var full_name:String;
		public var web_url:String;
		public var job_title:String;
		public var name:String;
		public var url:String;
	
		public var followers:Number;
		public var following:Number;
		public var updates:Number;
		
		private var _mughshoturl:String;

		public function YammerSubscription()
		{
		}
		
		/**
		 * Converts a subscription to a user, but does not 
		 * complete all user information because subscriptions only 
		 * contain limited information.
		 * 
		 * @return YammerUser (not full user info)
		 * */
		public function getYammerUser():YammerUser
		{
			var user:YammerUser = new YammerUser();
				user.id = this.id;
				user.type = this.type;
				user.mugshot_url = this.mugshot_url;
				user.full_name = this.full_name;
				user.web_url = this.web_url;
				user.job_title = this.job_title;
				user.url = this.url;
				user.name = this.name;
			return user;
		}
		
		/**
		 * Converts a subscription to a ag, but does not 
		 * complete all tag because subscriptions only 
		 * contain limited information.
		 * 
		 * @return YammerTag 
		 * */
		public function getYammerTag():YammerTag
		{
			var tag:YammerTag = new YammerTag();
				tag.id = this.id;
				tag.name = this.name;
				tag.url = this.url;
				tag.is_followed = true; // all subcriptions are followed
			return tag;
		}
		
		/**
		 * Converts a subscription to a user, but does not 
		 * complete all user information because subscriptions only 
		 * contain limited information.
		 * 
		 * @return YammerSubscription
		 * */
		public function createSubscriptionFromUser(value:YammerUser):YammerSubscription
		{
			var sub:YammerSubscription = new YammerSubscription();
				sub.id = value.id;
				sub.type = value.type;
				sub.mugshot_url = value.mugshot_url;
				sub.full_name = value.full_name;
				sub.web_url = value.web_url;
				sub.job_title = value.job_title;
				sub.url = value.url;
				sub.name = value.name;
			return sub;
		}
		
		/**
		 * Subscription mug shot url
		 * */
		public function get mugshot_url():String 
		{ 
			var u:String = _mughshoturl;
			if (!u) { return ""; }
			u = validateLink(u);
			return u;
		}
		
		public function set mugshot_url(value:String):void 
		{
			_mughshoturl = value;
		}	
		

		/**
		 * Function to validate mug shot url's.
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
