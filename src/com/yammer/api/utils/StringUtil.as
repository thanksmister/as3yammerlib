/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.utils
{
	public class StringUtil
	{
		/**
			Removes all tabs, returns, and linefeeds from String
			
			@param source: String to remove new lines.
			@return String with new lines removed.
		*/
		public static function replaceNewLines(s:String):String 
		{
			var pattern:RegExp= /\n|\r|\f|\t/g;
			return s.replace(pattern, ' ');
		}
		
		/**
		 Returns url encoded values for "< >" charcters.
		 
		 @param source: String to replace "< >" values
		 @return String without replaced "< >" valus
		 */
		public static function replaceHTML(value:String):String 
		{
			var pattern:RegExp= /\<|\>/g;  
			
			return value.replace(pattern, doReplaceHTML);
		}   

		private static function doReplaceHTML():String 
		{
			var c:String = arguments[0];
			
			switch (c) {
				case "<": return "&lt;"; break;
				case ">": return "&gt;"; break;
				default: return c;
			}     	 	
		}
	}
}