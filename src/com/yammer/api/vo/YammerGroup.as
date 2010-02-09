/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerPaths;
	import com.yammer.api.constants.YammerGroupTypes;
	
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
		
		public function isPrivate():Boolean
		{
			if(this.privacy == YammerGroupTypes.PRIVACY_PRIVATE){
				return true;
			}
			
			return false;
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
