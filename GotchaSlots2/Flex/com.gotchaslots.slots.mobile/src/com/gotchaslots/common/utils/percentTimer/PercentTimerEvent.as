package com.gotchaslots.common.utils.percentTimer
{
	import flash.events.Event;
	
	public class PercentTimerEvent extends Event
	{
		// events
		public static const Changed:String = "3551adc16f9b444496069b7cf36d5ca8";
		public static const ZeroReached:String = "292681e612d241a28a760ca142315da1";
		public static const ValueReached:String = "a51489cd058b43d4b30de9caa7ce14b4";
		public static const FullReached:String = "9e84bdf2528e4d2caded4be8fbf8ecc6";
		
		// members
		private var _percent:Number;
		
		// properties
		public function get Percent():Number
		{
			return _percent;
		}
		
		// class
		public function PercentTimerEvent(type:String, percent:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_percent = percent;
		}
	}
}