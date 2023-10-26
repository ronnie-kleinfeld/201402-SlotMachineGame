package com.gotchaslots.common.data.application.locale
{
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.NumberFormatter;
	
	public class L10NHandler extends EventDispatcherEx
	{
		// consts
		private static const LOCALE:String = "en";
		
		// members
		private var _dateFormatter:DateTimeFormatter;
		private var _timeFormatter:DateTimeFormatter;
		private var _numberFormatter:NumberFormatter;
		
		// properties
		public function get GetDateFormatter():DateTimeFormatter
		{
			if (!_dateFormatter)
			{
				_dateFormatter = new DateTimeFormatter(LOCALE);
				_dateFormatter.setDateTimeStyles(DateTimeStyle.SHORT, DateTimeStyle.NONE)
			}
			return _dateFormatter;
		}
		public function get GetTimeFormatter():DateTimeFormatter
		{
			if (!_timeFormatter)
			{
				_timeFormatter = new DateTimeFormatter(LOCALE);
				_timeFormatter.setDateTimePattern("HH:mm:ss");
				_timeFormatter.setDateTimeStyles(DateTimeStyle.NONE, DateTimeStyle.CUSTOM)
			}
			return _timeFormatter;
		}
		public function get GetNumberFormatter():NumberFormatter
		{
			if (!_numberFormatter)
			{
				var _numberFormatter:NumberFormatter = new NumberFormatter(LOCALE);
			}
			return _numberFormatter;
		}
		
		// class
		public function L10NHandler()
		{
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			_dateFormatter = null;
			_timeFormatter = null;
			_numberFormatter = null;
		}
	}
}