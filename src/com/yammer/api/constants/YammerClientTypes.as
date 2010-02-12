/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.constants
{
	public class YammerClientTypes
	{
		/** Update type */
		public static const EMAIL_TYPE:String = "Email";
		
		/** Web type */
		public static const WEB_TYPE:String = "Web";
		
		/** Web type */
		public static const DESKTOP_TYPE:String = "Desktop";
		
		public function YammerClientTypes() 
		{
			throw Error("The YammerClientTypes class cannot be instantiated.");
		}
	}
}
