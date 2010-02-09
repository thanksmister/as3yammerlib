/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo
{
	import com.yammer.api.constants.YammerAttachmentTypes;

	public class YammerAttachment
	{
		public var id:Number;
		public var type:String;
		public var name:String;
		public var web_url:String;
		public var url:String;
		public var thumbnail_url:String;
		public var size:Number;
		
		public function YammerAttachment()
		{
		}
		
		public function get is_image():Boolean 
		{ 
			return (type == YammerAttachmentTypes.IMAGE_TYPE); 
		}
		
		public function get is_file():Boolean 
		{ 
			return (type == YammerAttachmentTypes.FILE_TYPE); 
		}

		public function get link_to():String 
		{ 
			return "<a href=\"" + url + "\">" + name + "</a>"; 
		}  

	}
}
