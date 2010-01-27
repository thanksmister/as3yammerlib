/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import flash.utils.Dictionary;
	
	public class YammerSearch
	{
		public var search_term:String;
		
		public var users:Array;
		public var tags:Array;
		public var groups:Array;
		public var messages:Array;
		public var references:Dictionary;

		public var count_groups:Number = 0;
		public var count_messages:Number = 0;
		public var count_tags:Number = 0;
		public var count_users:Number = 0;
		
		public function YammerSearch() 
		{
		}
	}
}
