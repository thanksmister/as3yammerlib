/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo
{
	/**
	 * The YammerTabTypes class contains a list of types for home tabs in current user.
	 * */
	public class YammerTabTypes
	{
		/** All messages */
		public static const TAB_ALL:String = "all";
		
		/** RSS feeds followed */
		public static const TAB_RSS:String = "rss";
		
		/** Favorited messages */
		public static const TAB_FAVORITES:String = "favorite";
		
		/** Bookmarks */
		public static const TAB_BOOKMARKED:String = "bookmark";
		
		/** Direct messages */
		public static const TAB_PRIVATE:String = "private";
		
		/** Favorited messages */
		public static const TAB_LIKE:String = "like";
		
		/** Sent messages */
		public static const TAB_SENT:String = "sent";
		
		/** Received messages */
		public static const TAB_RECEIVED:String = "received";
		
		/** Users followed messages (My Feed) */
		public static const TAB_FOLLOWING:String = "following";
		
		/** Users followed groups */
		public static const TAB_GROUP:String = "group";
		
		public function YammerTabTypes() 
		{
		}
		
		/**
		 * Returns a list of main home tabs (no groups)
		 * 
		 * @param tabList List of home tabs for current user
		 * @return Array list of main tabs for current user
		 * */
		public static function mainTabs(tabList:Array):Array
		{	
			var temp:Array = new Array();
			for each (var tab:YammerTab in tabList){
				if(tab.type != TAB_GROUP){
					temp.push(tab);
				}
			}
			
			return temp;
		}
		
		/**
		 * Returns a list of group home tabs (no groups)
		 * 
		 * @param tabList List of home tabs for current user
		 * @return Array list of group tabs for current user
		 * */
		public static function groupTabs(tabList:Array):Array
		{	
			var temp:Array = new Array();
			for each (var tab:YammerTab in tabList){
				if(tab.type == TAB_GROUP){
					temp.push(tab);
				}
			}
			
			return temp;
		}
		
		
	}
}
