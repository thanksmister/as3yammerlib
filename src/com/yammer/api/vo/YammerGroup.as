/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.YammerPaths;
	
	public class YammerGroup 
	{
		public var name:String;
		public var id:String;
		public var full_name:String;
		public var description:String;
		public var type:String;
		public var url:String;
		public var web_url:String;
		public var privacy:String;
		
		public var members:Number;
		public var updates:Number;
		private var _mugshoturl:String;
		
		public var is_private:Boolean = false; // convienance flag for private group
		public var has_joined:Boolean = false; // convienance flag set when current user follows group
		
		public function YammerGroup(){}
		
		public function set mugshot_url(value:String):void 
		{
			_mugshoturl = value;
		}		
		
		public function get mugshot_url():String 
		{ 
			var u:String = _mugshoturl;
			if (!u) { return ""; }
			u = validateLink(u);
			return u;
		}
		
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
