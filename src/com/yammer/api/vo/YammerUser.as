/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerPaths;
	
	public class YammerUser	
	{
		public var id:String;
		public var type:String;
		public var url:String;
		public var web_url:String;
		public var name:String;
		public var full_name:String;
		
		private var _mugShotURL:String;
		
		public var network_id:Number;
		public var network_name:String;
		
		public var hire_date:String;
		public var birth_date:String;
		public var job_title:String;

		public var email_addresses:Array;
		public var im:Array;
		public var phone_numbers:Array;

		public var kids_names:String;
		public var significant_other:String;
		public var location:String;
		public var state:String;

		public var followers:Number;
		public var following:Number;
		public var updates:Number;
		

		public function YammerUser()
		{
		}
		

		/** 
		 * User mug shot url.
		 * */
		public function get mugshot_url():String 
		{ 
			var u:String = _mugShotURL;
			if (!u) { return ""; }
			u = validateLink(u);
			return u;
		}
		
		public function set mugshot_url(m:String):void 
		{
			_mugShotURL = m;
		}
		
		/**
		 * Returns the user's primary email address.
		 * */
		public function getEmailAddress():String
		{
			return email_addresses[0].address;
		}
		
		/**
		 * Returns short of full name based on 
		 * boolean flag 'show_full_names' value.
		 * */
		[Inspectable(enumeration="full, short", defaultValue="full")]
		public function getName(type:String):String 
		{
			return (type == "full") ? full_name : name;
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
