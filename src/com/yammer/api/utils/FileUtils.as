/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.utils
{
	import mx.collections.ArrayCollection;
	import mx.formatters.NumberFormatter;
	
	public class FileUtils
	{
		/**
		 * Maximum allowed file size for video transencoding of uploaded files files.  This is optional
		 * to use with the maxFileSize() function, and since its public, you can reset this value
		 * to any max file size you would like to use within the maxFileSize() funciton.
		 */
		public static var MAX_FILE_SIZE:Number = 100000000; // flash upload limit 100MB
		
		private var numberFormatter:NumberFormatter;
		
		/**
	 	* File utitlies constructor
	 	*/
		public function FileUtils()
		{
		}
		
		
		/**
		 * Determines the total size of files being uploaded.
		 * @param list List of files
		 * @return Number
		 */
		public static function totalSize(files:Array):Number
		{
			var num:Number = 0;
			for each (var obj:Object in files){
				num += Number(obj.size);	
			}
			return Math.round(num/1024);
		}
    	
    	/**
		 * Determines if a file already exists in a list of files by comparing ids.
		 * @param list List of files
		 * @param file The file to compare against the list
		 * @return Boolean
		 */
    	public static function duplicateIdCheck(list:Array, file:Object):Boolean
    	{
    		for each(var obj:Object in list)
    		{
    			try{
    				if(obj.name == file.name) return true;
    			} catch(e:Error){trace(e.message); return true}
    			
    		}
    		return false;
    	}
    	
    	/**
		 * Determines if a file is over the maximum upload limit for Flash files using
		 * the Flash Player to upload.
		 * @param size Number reresenting the size of the asset or file
		 * @return Boolean
		 */
    	public static function maxFileSize(size : Number):Boolean
    	{
    		if(size < MAX_FILE_SIZE) return true;
    		return false;
    	}
    	
    	/**
		 * Returns the size of a file or asset with the correct unit name (B,KB,MB,GB).
		 * @param size Number reresenting the size of the asset or file
		 * @return String
		 */
		public static function formatSize(size : Number):String
		{
			var units:String;
			var test:Number = 1024;
			var numberFormatter:NumberFormatter = new NumberFormatter();
			
			if (size < test){
				units = "B";
			} else if (size < (test *= 1024)) {
				units = "KB";
			} else if (size < (test *= 1024)) {
				units = "MB";
			} else if (size < (test *= 1024)) {
				units = "GB";
			}
			
			var num:Number = size/(test/1024)*100;
			return (numberFormatter.format(Math.round(num)/100) + units);
		}	
		
		/**
		 * Returns the extension of the asset.
		 * @param name The name of the asset
		 * @return String
		 */
		public static function fileExtension(name:String):String
		{
			var dotindex:int = name.lastIndexOf('.') != -1 ? (name.lastIndexOf('.') + 1) : name.length;
		    var type:String = name.substr(dotindex, name.length).toLocaleLowerCase();
		    return type;
		}
		
		/**
		 * Returns the name of the asset without the extension.
		 * @param name The name of the asset
		 * @return String
		 */
		public static function fileName(name:String):String
		{
			var dotindex:int = name.lastIndexOf('.') != -1 ? (name.lastIndexOf('.') ) : name.length;
		    var trimname:String = name.substr(0, dotindex);
		    return trimname;
		}
		
		/**
		 * Determines if asset is a file can be displayed using Flash either natively or
		 * through tansencoding processes.  
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isFlashMediaType(type:String):Boolean
		{
			if (type == null) return false;
			type = type.toLocaleLowerCase();
	
			switch (type)
			{
				case "gif":
				case "mp3":					
				case "jpg":
				case "jpeg":		
				case "png":			
				case "flv":
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is a video asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isVideo(type:String):Boolean
		{
			if (type == null) return false;
			type = type.toLocaleLowerCase();
		
			switch (type)
			{		
				case "mpeg":
				case "avi":
				case "wmv":
				case "mpg":
				case "mov":
				case "flv":
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is an image asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isImage(type:String):Boolean
		{
			if (type == null) return false;
			type = type.toLocaleLowerCase();

			switch (type)
			{		
				case "gif":				
				case "jpg":
				case "jpeg":		
				case "png":	
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is a music asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isMusic(type:String):Boolean
		{
			if (type == null) return false;
			type = type.toLocaleLowerCase();
			
			switch (type){		
				case "mp3":					
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
		/**
		 * Determines if asset is a PDF asset by file extension
		 * @param type Extension of the asset
		 * @return Boolean
		 */
		public static function isPDF(type:String):Boolean
		{
			if (type == null) return false;
			type = type.toLocaleLowerCase();
	
			switch (type)
			{		
				case "pdf":						
					return true;
	
				default:
					return false;
			}		
			
			return false;		
		}
		
	}
}