/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	import com.yammer.api.constants.YammerTypes;

	public class YammerNetworkCurrent
	{
		public var name:String;
		public var id:String;
		public var type:String = YammerTypes.NETWORK_TYPE;
		public var unseen_messsage_count:Number = 0;
		public var permalink:String;
		
		public function YammerNetworkCurrent() 
		{		
		}
	}
}
