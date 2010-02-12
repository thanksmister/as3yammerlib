/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.utils
{
	import com.yammer.api.constants.YammerTypes;
	import com.yammer.api.vo.YammerGroup;
	import com.yammer.api.vo.YammerMessage;
	import com.yammer.api.vo.YammerTag;
	import com.yammer.api.vo.YammerUser;

	public class MessageUtilities
	{
		public function MessageUtilities():void
		{
			throw Error("The MessageUtilities class cannot be instantiated.");
		}
		
		/**
		 URLEncode the body text of the message before sending it to the service.
		 
		 @param message: Yammer message to url encode.
		 @return Yammer message url encoded.
		 */
		public static function urlEncodeMessage(message:YammerMessage):YammerMessage
		{
			message.body_plain = encodeURIComponent(message.body_plain);
			return message;
		}
		
		/**
		 Truncate the value of String to desired length removing new line breaks and adds ellipses <code>...</code> to returned String.
		 
		 @param value: String to truncate.
		 @param len: Number of characters to truncate to.
		 @pram ellipses: Boolean value to add ellipses to truncated text.
		 @return String with truncated text.
		 */
		public static function truncateText(value:String, len:Number, ellipses:Boolean = true):String
		{
			if (!value) { return ""; }
			if (value.length > len) {
				value = value.substr(0, len);
				if (ellipses) {	value += "...";	}
			}
	
			return StringUtil.replaceNewLines(value);
		}
		
		/**
		 Truncate the value of HTML text to desired length removing new line breaks and adds ellipses <code>...</code> to returned String.
		 
		 @param value: HTML text to truncate.
		 @param limit: Number of characters to truncate to.
		 @pram ellipses: Boolean value to add ellipses to truncated text.
		 @return String with truncated HTML text.
		 */
		public static function truncateHTMLText(value:String, limit:Number, eillipses:Boolean = true):String
		{
			if(limit == 0)
				return "";
			
			var original:String = value;
			
			value = value.replace("[\\t\\n\\x0B\\f\\r\\u00A0]+", "");
			
			var isTag:Boolean = false;
			var count:int = 0;
			var position:int = 0;
			var limitLength:int = value.length - 1;
			var closeTag:Boolean = false;
			
			for(var i:int = 0; i < value.length; i++) {
				var c:String = value.charAt(i);
				if(isTag) {
					if(c == '>') {
						isTag = false;
						if(closeTag || i == limitLength) {
							position = i;
							break;
						}
						continue;
					} else {
						continue;
					}
				} else {
					if(c == '<') {
						isTag = true;
					} else {
						count++;
						if(i == limitLength || (count == limit)) {
							if(((i+1) < limitLength) && ((i+2) < limitLength)) {
								if(value.charAt(i+1) == '<' && value.charAt(i+2) == '/') {
									closeTag = true;
									continue;
								}
							}
							position = i;
							break;
						}
					}
				}
			}
			
			var result:String = value.substring(0, position + 1);
			var last:String = result.charAt(result.length - 1);
			var length:int = result.length;
			
			var nextChar:String = (length >= value.length) ? ' ' : value.charAt(length);
			
			if(last != ' ' && last != '>' && nextChar != ' ' && nextChar != '<')
				result = result.substring(0, result.lastIndexOf(' ') + 1);
			var lastStartTag:int = result.lastIndexOf('<');
			
			if(lastStartTag != -1) {
				var ch:String = result.charAt(lastStartTag + 1);
				if(ch != '/') {
					result = result.substring(0, lastStartTag);
				}
			}
			
			if(original.length == result.length)
				return original;
			
			if(result.length == 0)
				return result;
			
			if((original.length - result.length < 50)) return original; // fuzzy border of 50 characters
			
			var pattern:RegExp = new RegExp("(.*?)(\\s*\.\.\.\\s*)([\</[a-z]*?\>\\s*$]+)", "i");
			
			if(result.search(pattern) == -1)
				result += "... ";
			
			return (result +  "<a href=\"event:more\">[more]</a>");
		}
		
		/**
		 * Remove line breaks from messages.
		 * 
		 * @param s String of text to remove lines
		 * @return String of text without line breaks
		 * */
		public static function stripNewlines(s:String):String 
		{
			var pattern:RegExp= /\n|\r|\f|\t/g;
			return s.replace(pattern, '');
		}
		
		/**
		 Formats a list of yammer messages and replaces link references with HTML formatted links.
		 
		 @param messages Array of messages to format.
		 @return messages Array of formatted.
		 */
		public static function formatMessages(messages:Array):Array
		{
			for each (var message:YammerMessage in messages){
				
				message.body_parsed = formatMessageBody(message.body_parsed);
				
				/*
				if(message.type == YammerMessageTypes.SYSTEM || message.type == YammerMessageTypes.BROADCAST){
					if(message.sender_type == YammerTypes.TAG_TYPE){
						message.body_parsed = "<b><a href=\"" + "tag:" + message.sender.id + "\">" + message.sender.name + "</a></b> " + message.body_parsed;
					} else if (message.sender_type == YammerTypes.USER_TYPE){
						message.references.push(message.sender);
						if(message.type == YammerMessageTypes.BROADCAST) {
							message.body_parsed =  "<b><a href=\"" + "user:" + message.sender.id   + "\">" + message.sender.full_name + "</a> (Broadcast)</b>\n" + message.body_parsed;
						} else {
							message.body_parsed =  "<b><a href=\"" + "user:" + message.sender.id   + "\">" + message.sender.full_name + "</a></b> " + message.body_parsed;
						}
					} else if (message.sender_type == YammerTypes.GROUP_TYPE){
						message.body_parsed =   "<b><a href=\"" + "group:" + message.sender.id   + "\">" + message.sender.full_name + "</a></b> " + message.body_parsed;
					} else if (message.sender_type == YammerTypes.BOT_TYPE){
						message.body_parsed =  "<b><a href=\"" + "bot:" + message.sender.id   + "\">" + message.sender.full_name + "</a></b> " + message.body_parsed;
					} 
				}
				*/
			}
			
			return messages;
		}
		
		public static function formatMessageBody(message_body:String):String
		{
			message_body = formatBody(message_body);
			return message_body;
		}
		
		/**
		 * This function will iterate through all messages in a message list
		 * and set the time stamp based on the current users preferences for 
		 * absolute time stamps.
		 * 
		 * @param messages with messages to adjust time stamp
		 * @param absolute_timestmaps Boolean flag to show absolute time stamps
		 * @return Array with messages time stamps updated
		 * */
		public static function setTimeStamp(messages:Array, absolute_timestmaps:Boolean = false):Array
		{
			for each (var message:YammerMessage in messages) {
				var date:Date = new Date(message.created_at);
				message.display_time = (absolute_timestmaps)? DateUtilities.absoluteTimestamp(date):DateUtilities.timeAgoWords(Number(message.created_at));
			}
			return messages;
		}
		
		private static function formatBody(value:String):String 
		{						
			value = StringUtil.replaceHTML(value);
	
			// replace referecnes within the message text with html links
			var pattern:RegExp= /\[\[([^\[\]]*?)\]\]/g; 
			value = value.replace(pattern, replaceReference);
			
			// replace html links with clickable html links using event links in text box
			pattern = /((?:http(?:s?)\:\/\/|www\.[^\.])\S+[A-z0-9\/])/g; 
			value = value.replace(pattern, cleanHTML);
			
			return value;
		}
		
		private static function cleanHTML(matchedSubstring:String, capturedMatch:String, index:int, str:String):String
		{
			/*
			trace("MessageUtilities :: matched: " + matchedSubstring);
			trace("MessageUtilities :: captured: " + capturedMatch);
			trace("MessageUtilities :: index: " + index);
			trace("MessageUtilities :: str: " + str);
			*/
			capturedMatch = checkLink(capturedMatch);
			
			return "<a href=\"" + capturedMatch + "\" target='_blank'>" + truncateText(capturedMatch, 30) + "</a>";
		}
		
		private static function replaceReference(matchedSubstring:String, capturedMatch:String, index:int, str:String):String
		{
			trace("MessageUtilities :: matched: " + matchedSubstring);
			trace("MessageUtilities :: captured: " + capturedMatch);
			trace("MessageUtilities :: index: " + index);
			trace("MessageUtilities :: str: " + str);
			
			var split:Array = capturedMatch.split(":");
			var id:String = split[1];
			var type:String = split[0];
			
			// retrieve object from references
			if(type == YammerTypes.TAG_TYPE){
				var tag:YammerTag = CacheManager.instance.getTag(id);
				return "#<a href=\"" + capturedMatch + "\">" + tag.name + "</a>";
			} else if (type == YammerTypes.USER_TYPE){
				var user:YammerUser = CacheManager.instance.getUser(id);
				return "@<a href=\"" + capturedMatch + "\">" + user.name + "</a>";
			} else if (type == YammerTypes.GROUP_TYPE){
				var group:YammerGroup = CacheManager.instance.getGroup(id);
				return  "<a href=\"" + capturedMatch + "\">" + group.full_name + "</a>";
			} else if (type == YammerTypes.BOT_TYPE){
				var bot:YammerUser = CacheManager.instance.getBot(id); 
				return "<a href=\"" + capturedMatch + "\">" + bot.full_name + "</a>";
			}  
			
			return matchedSubstring;
		}
	
		private static function checkLink(s:String):String 
		{
			var pattern:RegExp=/http(?:s?)\:\/\//; 
			var t:Array = s.match(pattern);
			return (!t) ? "http://" + s : s; 
		}

	}
}