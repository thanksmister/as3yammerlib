/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	public class YammerNetwork
	{
		public var user_id:String;
		public var secret:String;
		public var token:String;
		public var network_name:String;
		public var network_id:String;
		public var network_permalink:String;
		
		public var created_at:Date = new Date();
		public var authorized_at:Date = new Date();
		
		public var modify_messages:Boolean = true;
		public var modify_subscriptions:Boolean = true;
		public var view_groups:Boolean = true;
		public var view_messages:Boolean = true;
		public var view_subscriptions:Boolean = true;
		public var view_members:Boolean = true;
		public var view_tags:Boolean = true;
		
		public function YammerNetwork() 
		{		
		}
	}
}
