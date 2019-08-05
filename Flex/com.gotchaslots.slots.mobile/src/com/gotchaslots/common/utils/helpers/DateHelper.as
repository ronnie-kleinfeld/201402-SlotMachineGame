package com.gotchaslots.common.utils.helpers
{
	import flash.globalization.DateTimeFormatter;

	// formatting
	// http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/globalization/DateTimeFormatter.html
	public class DateHelper
	{
		public static function Format_ddMMyyyy_hhmmss(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter("he-IL");
			dtf.setDateTimePattern("dd/MM/yyyy hh:mm:ss");
			return dtf.format(date); 
		}
		public static function Format_ddMMyyyy_hhmmssSSS(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter("he-IL");
			dtf.setDateTimePattern("dd/MM/yyyy hh:mm:ss.SSS");
			return dtf.format(date); 
		}
	}
}