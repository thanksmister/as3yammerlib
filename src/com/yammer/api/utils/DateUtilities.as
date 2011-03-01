/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 * @version 11.03.09
 */
package com.yammer.api.utils
{
	public class DateUtilities
	{
	  	private static var SHORT_MONTHS:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	  	private static var FULL_MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];	
      	
 		public function DateUtilities() 
        { 
        }
 		
      	public static function timeAgoWords(date:Date, include_seconds:Boolean = false):String 
      	{
      		var curdate:Date = new Date()
      		return distanceTimeWords(Number(date), curdate.time, include_seconds) + " ago";
		}   
    
	    public static function absoluteTimestamp(date:Date):String 
	    {
	    	var s:String = localHours(date.hours) + ":" + localMinutes(date.minutes) + " " + meridiem(date.hours) + " - " + simpleCalendarDate(date); 
	      	return s;
	    }
	    
	    private static function localMinutes(m:Number):String 
	    {
	    	return (m < 10) ? "0" + m.toString() : m.toString();
	    }
	     
	    private static function localHours(h:Number):Number 
	    {
	    	if (h==0) { return 12; }
	    	return (h > 12) ? (h-12) : h;
	    }
	    
	    private static function meridiem(h:Number):String 
	    {
	    	return (h > 11) ? "PM" : "AM";
	    }
	    
	    private static function simpleCalendarDate(date:Date):String 
	    {
	    	var curdate:Date = new Date();
	        return (curdate.toDateString ()  == date.toDateString()) ? "Today" : localShortMonth(date.month) + " " + date.date;
	    }
	    
	    private static function localShortMonth(m:Number):String 
	    {
	    	return SHORT_MONTHS[m];
	    }
    
		private static function distanceTimeWords(from_time:Number, to_time:Number, include_seconds:Boolean=false):String 
		{
			if (! to_time) to_time = 0;  
			var distance_in_minutes:Number = Math.round(((Math.abs(to_time - from_time))/60000))
			var distance_in_seconds:Number =  Math.round(((Math.abs(to_time - from_time))/1000))
			
			if (between(distance_in_minutes,0,1)) {
				if (!include_seconds) return (distance_in_minutes == 0) ? 'a moment' : '1 minute';
			    if (between(distance_in_seconds,0,4))   return '5 seconds';
			    if (between(distance_in_seconds,5,9))   return '10 seconds';
			    if (between(distance_in_seconds,10,19)) return '20 seconds';
			    if (between(distance_in_seconds,20,29)) return '30 seconds';
			    if (between(distance_in_seconds,30,39)) return '40 seconds';
			    if (between(distance_in_seconds,40,49)) return '50 seconds';
			    return '1 minute';
			}
			 
			if (between(distance_in_minutes,2,44))           return distance_in_minutes + " minutes";
			if (between(distance_in_minutes,45,89))          return '1 hour';
			if (between(distance_in_minutes,90,1439))        return Math.round(distance_in_minutes / 60.0) + " hours";
			if (between(distance_in_minutes,1440,2879))      return '1 day';
			if (between(distance_in_minutes,2880,43199))     return Math.round(distance_in_minutes / 1440) + " days";
			if (between(distance_in_minutes,43200,86399))    return '1 month';
			if (between(distance_in_minutes,86400,525599))   return Math.round(distance_in_minutes / 43200) + " months";
			if (between(distance_in_minutes,525600,1051199)) return '1 year';
			
			return "over " + Math.round(distance_in_minutes / 525600) + " years";
		}

		private static function between(num:Number,min:Number,max:Number):Boolean 
		{
			if (min > num || max < num) {
		    	return false;
		  	} else {
		    	return true;
		  	}
		}
	}
}