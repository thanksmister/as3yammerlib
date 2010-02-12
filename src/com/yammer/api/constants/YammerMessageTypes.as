/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.constants
{
	public class YammerMessageTypes
	{	
		/** Subordinate type */
		public static const SYSTEM:String = "system";
		
		/** Superior type */
		public static const BROADCAST:String = "broadcast";
		
		/** Email type */
		public static const UPDATE:String = "update";
		
		public function YammerMessageTypes() 
		{
			throw Error("The YammerMessageTypes class cannot be instantiated.");
		}
	}
}
