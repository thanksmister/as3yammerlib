/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	/**
	 * YammerTab value object to sdtore the current users home tabs as displayed on web page.
	 * */
	public class YammerTab
	{
		public var name:String;
		public var url:String;
		public var type:String;
		public var select_name:String;
		public var ordering_index:String;
		public var is_private:Boolean = false;
		public var group_id:String;
		public var feed_description:String;

		public function YammerTab()
		{
		}
	}
}