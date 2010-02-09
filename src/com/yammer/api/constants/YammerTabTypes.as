/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.constants
{
	import com.yammer.api.vo.YammerTab;

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
			throw Error("The YammerTabTypes class cannot be instantiated.");
		}
	}
}
