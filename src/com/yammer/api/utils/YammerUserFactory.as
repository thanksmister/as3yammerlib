/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.utils
{
	import com.yammer.api.vo.YammerCurrentUser;
	import com.yammer.api.vo.YammerEmail;
	import com.yammer.api.vo.YammerIM;
	import com.yammer.api.vo.YammerPhone;
	import com.yammer.api.vo.YammerSubscription;
	import com.yammer.api.vo.YammerTab;
	import com.yammer.api.vo.YammerUser;
	
	public class YammerUserFactory
	{
		public function YammerUserFactory()
		{
			throw Error("The YammerUserFactory class cannot be instantiated.");
		}
		
		public static function createCurrentUser(obj:Object):YammerCurrentUser
		{
			var user:YammerCurrentUser = new YammerCurrentUser();
			
			if(obj.id) user.id = obj.id;
			
			if(obj.type) user.type = obj.type;
			if(obj.url) user.url = obj.url;  
			if(obj.web_url) user.web_url = obj.web_url;
			if(obj.mugshot_url) user.mugshot_url = obj.mugshot_url;
			if(obj.name) user.name = obj.name;
			if(obj.full_name) user.full_name = obj.full_name;
			
			// network
			if(obj.network_id) user.network_id = obj.network_id;
			if(obj.network_name) user.network_name = obj.network_name;
			
			// personal info
			if(obj.birth_date) user.birth_date = obj.birth_date;	
			if(obj.hire_date) user.hire_date = obj.hire_date;
			if(obj.job_title) user.job_title = obj.job_title;
			if(obj.kids_names) user.kids_names = obj.kids_names;
			if(obj.significant_other) user.significant_other = obj.significant_other;
			
			if(obj.contact){
				if(obj.contact.phone_numbers) user.phone_numbers =  parsePhoneNumbers(obj.contact.phone_numbers as Array);
				if(obj.contact.im) user.im =  parseInstantMessaging(obj.contact.im as Array);
				if(obj.contact.email_addresses) user.email_addresses =  parseEmail(obj.contact.email_addresses as Array);
			}
			
			if(obj.location) user.location = obj.location;
			if(obj.state) user.state = obj.state;
			
			// stats
			if(obj.stats){
				user.followers = obj.stats.followers;
				user.following = obj.stats.following;
				user.updates = obj.stats.updates;
			}
			
			
			try {	    
				// web-preferences
				if(obj.web_preferences){
					user.enter_does_not_submit_messages = (obj.web_preferences.enter_does_not_submit = "true")? true:false;	
					user.show_full_names = (obj.web_preferences.show_full_names == "true")? true:false;	;
					user.absolute_timestmaps = (obj.web_preferences.absolute_timestmaps == "true")? true:false;
					user.allow_attachments = (obj.web_preferences.network_settings.allow_attachments == "true")? true:false;
					user.message_prompt = obj.web_preferences.network_settings.message_prompt;
					if(obj.web_preferences.home_tabs) user.tabs = parseTabs(obj.web_preferences.home_tabs as Array);
				}
				
				if(obj.subscriptions) user.subscriptions = parseSubscriptions(obj.subscriptions as Array);
				
			} catch (error:Error){
				throw new Error("Exception parsing current user: " + "\nError: " + error.message);
			}
			
			return user;
		}
		
		public static function createUser(obj:Object):YammerUser
		{
			var user:YammerUser = new YammerUser();
			
			try {	    
				if(obj.id) user.id = obj.id;
				
				if(obj.type) user.type = obj.type;
				if(obj.url) user.url = obj.url;  
				if(obj.web_url) user.web_url = obj.web_url;
				if(obj.mugshot_url) user.mugshot_url = obj.mugshot_url;
				if(obj.name) user.name = obj.name;
				if(obj.full_name) user.full_name = obj.full_name;
				
				// network
				if(obj.network_id) user.network_id = obj.network_id;
				if(obj.network_name) user.network_name = obj.network_name;
				
				// personal info
				if(obj.birth_date) user.birth_date = obj.birth_date;	
				if(obj.hire_date) user.hire_date = obj.hire_date;
				if(obj.job_title) user.job_title = obj.job_title;
				if(obj.kids_names) user.kids_names = obj.kids_names;
				if(obj.significant_other) user.significant_other = obj.significant_other;
				
				if(obj.contact){
					if(obj.contact.phone_numbers) user.phone_numbers =  parsePhoneNumbers(obj.contact.phone_numbers as Array);
					if(obj.contact.im) user.im =  parseInstantMessaging(obj.contact.im as Array);
					if(obj.contact.email_addresses) user.email_addresses =  parseEmail(obj.contact.email_addresses as Array);
				}
				
				if(obj.location) user.location = obj.location;
				if(obj.state) user.state = obj.state;
				
				// stats
				if(obj.stats){
					user.followers = obj.stats.followers;
					user.following = obj.stats.following;
					user.updates = obj.stats.updates;
				}
	
				
				obj = null;
			
			} catch (error:Error){
				throw new Error("Exception parsing user: " + "\nError: " + error.message);
			}
			
			return user;
		}
		
		private static function parsePhoneNumbers(numbers:Array):Array 
		{
			var list:Array = new Array();
			
			try{
				for each (var obj:Object in numbers){
					var phone:YammerPhone = new YammerPhone();
						phone.type = obj.type;
						phone.number = obj.number;
					list.push(phone);
				}
			} catch (error:Error){
				throw new Error("Exception parsing user phone numbers: " + "\nError: " + error.message);
			}
			
			return list;
		}

		private static function parseEmail(emails:Array):Array 
		{
			var list:Array = new Array();
			try{
				for each (var obj:Object in emails){
					var email:YammerEmail = new YammerEmail();
						email.type = obj.type;
						email.address = obj.address;
					list.push(email);
				}
			} catch (error:Error){
				throw new Error("Exception parsing user email: " + "\nError: " + error.message);
			}
			return list;
		}

		private static function parseInstantMessaging(ims:Array):Array 
		{
			var list:Array = new Array();
			try{
				for each (var obj:Object in ims){
					var im:YammerIM = new YammerIM();
						im.provider = obj.provider;
						im.username = obj.username;
					list.push(im);
				}
			} catch (error:Error){
				throw new Error("Exception parsing user im names: " + "\nError: " + error.message);
			}
			return list;
		}   
		
		private static function parseTabs(tabs:Array):Array 
		{
			var list:Array = new Array();
			try{
				for each (var obj:Object in tabs){
					var tab:YammerTab = YammerFactory.tab(obj);
					list.push(tab);
				}
			} catch (error:Error){
				throw new Error("Exception parsing im user tabs: " + "\nError: " + error.message);
			}
			return list;
		}

		private static function parseSubscriptions(subscriptions:Array):Array 
		{
			trace("YammerUserFactory :: parseSubscriptions: " +  subscriptions );
			
			var list:Array = new Array();
			try{
				for each (var obj:Object in subscriptions){
					var subscription:YammerSubscription = YammerFactory.subscription(obj);
					
					list.push(subscription);
				}
			} catch (error:Error){
				throw new Error("Exception parsing im user subscriptions: " + "\nError: " + error.message);
			}
			return list;
		}   

	}
}