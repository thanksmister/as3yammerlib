/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.constants
{

	public class YammerPaths
	{
		public static function get BASE_URL():String 
		{
			return YammerURL.BASE_URL;
		}

		public static function get API():String {
			return BASE_URL + "api/v1/";
		}
		
		public static function get JSON():String {
			return ".json";
		}

		public static function get ACCOUNT():String {
			return BASE_URL + "account/";
		}

		private static function get OAUTH():String {
			return BASE_URL + "oauth/";
		}	 
		
		private static function get OAUTH_WRAP():String {
			return BASE_URL + "oauth_wrap/";
		}	 

		public static function get OAUTH_REQUEST_TOKEN():String {
			return OAUTH + "request_token";
		}

		public static function get OAUTH_ACCESS_TOKEN():String {
			return OAUTH + "access_token";
		}

		public static function get OAUTH_AUTHORIZE():String {
			return OAUTH + "authorize";
		}
		
		public static function get OAUTH_WRAP_ACCESS_TOKEN():String {
			return OAUTH_WRAP + "access_token";
		}
		
		public static function get NO_ACCESS():String {
			return BASE_URL + "home"
		} 
		
		public static function get NETWORKS():String {
			return API + "oauth/tokens.json";
		}	
		
		public static function get NETWORKS_CURRENT():String {
			return API + "networks/current.json";
		}	      

		public static function get DELETE():String {
			return API + "messages/";
		}  

		public static function get INVITE():String {
			return API + "invitations.json";
		}
		
		public static function get USER_BY_EMAIL():String {
			return API + "users/by_email.json";
		}

		public static function get MESSAGES():String {
			return API + "messages/";
		}
		
		public static function get FAVORITES():String {
			return MESSAGES + "favorites_of/";
		}
		
		public static function get LIKED():String {
			return MESSAGES + "liked_by/";
		}
		
		public static function get POST_MESSAGE():String {
			return API + "messages.json";
		}	  

		public static function get TAGS():String {
			return API + "tags/";
		}  

		public static function get USERS():String {
			return API + "users/";
		} 

		public static function get FILES():String {
			return API + "files/";
		} 

		public static function get USER_LOG():String {
			return API + "user_log/";
		} 

		public static function get GROUPS():String {
			return API + "groups/";
		} 

		public static function get GROUP_MEMBERSHIPS():String {
			return API + "group_memberships.json";
		} 

		public static function get RELATIONSHIPS():String {
			return API + "relationships/";
		} 

		public static function get REQUESTS():String {
			return API + "requests.json";
		} 

		public static function get SUGGESTIONS():String {
			return API + "suggestions/";
		}

		public static function get ALL_USERS():String {
			return API + "users.json";
		} 	
		
		public static function get ALL_GROUPS():String {
			return API + "groups.json";
		} 
		
		public static function get SEARCH():String {
			return API + "search.json";
		}  

		public static function get CURRENT_USER():String {
			return USERS + "current.json";
		} 			

		public static function get SUBSCRIPTIONS():String {
			return API + "subscriptions/";
		}

		public static function get TYPEAHEAD():String {
			return API + "autocomplete.json";
		}

		public static function get MESSAGES_FROM_USER():String {
			return "from_user/";
		}
		
		public static function get MESSAGES_FROM_BOT():String {
			return "from_bot/";
		}
		
		public static function get MESSAGES_RSS_FEEDS():String {
			return "rss_feeds/";
		}

		public static function get MESSAGES_IN_THREAD():String {
			return "in_thread/";
		}

		public static function get MESSAGES_IN_GROUP():String {
			return "in_group/";
		}   

		public static function get MESSAGES_TAGGED_WITH():String {
			return "tagged_with/";
		}
		
		public static function get TO_USER():String {
			return "to_user/";
		} 
		
		public function YammerPaths() 
		{
			throw Error("The YammerPaths class cannot be instantiated.");
		}
	}
}
