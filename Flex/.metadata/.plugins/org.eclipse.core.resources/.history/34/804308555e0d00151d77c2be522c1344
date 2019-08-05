package com.gotchaslots.common.utils.helpers
{
	import com.gotchaslots.common.data.Main;
	
	import flash.globalization.NumberFormatter;
	
	public class FormatterHelper
	{
		public static function DateToDate(date:Date):String
		{
			return Main.Instance.Application.L10N.GetDateFormatter.format(date);
		}
		public static function DateToTime(date:Date):String
		{
			return Main.Instance.Application.L10N.GetTimeFormatter.format(date);
		}
		public static function NumberToMoney(value:Number, fractionalDigits:int = 2, showPrecisionMinimumValue:Number = 100):String
		{
			try
			{
				var result:String;
				
				var numberFormatter:NumberFormatter = Main.Instance.Application.L10N.GetNumberFormatter;
				
				if (showPrecisionMinimumValue >= 0 && value > showPrecisionMinimumValue)
				{
					numberFormatter.fractionalDigits = 0;
					result = numberFormatter.formatNumber(value);
				}
				else
				{
					numberFormatter.fractionalDigits = fractionalDigits;
					result = numberFormatter.formatNumber(value);
				}
			}
			catch (error:Error)
			{
				result = "";
			}
			
			return result;
		}
	}
}