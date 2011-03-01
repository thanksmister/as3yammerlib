/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerTypes;

	public class YammerThread
	{
		public var id:Number;
		public var type:String = YammerTypes.THREAD_TYPE;
		public var thread_starter_id:String;
		public var web_url:String;
		public var url:String;
		public var lastest_reply_at:Date = new Date();
		public var lastest_reply_id:String;
		public var first_reply_id:String;
		public var first_reply_at:Date = new Date(); 
		public var updates:Number;
		
		public function YammerThread() 
		{
		}
	}
}
