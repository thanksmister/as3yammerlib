/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerTypes;

	public class YammerGroupRequest 
	{
		public var id:Number;
		public var type:String = YammerTypes.GROUP_TYPE;
		
		public var user_id:String;
		public var group_id:String;
		public var inviter_ids:Array;
		public var web_url:String;
		public var url:String;
		public var created:Date;
		
		public static var JOIN_REQUEST:String = "group";
		public static var GROUP_REQUEST:String = "join";

		public function YammerGroupRequest()
		{
		}

	}
}
