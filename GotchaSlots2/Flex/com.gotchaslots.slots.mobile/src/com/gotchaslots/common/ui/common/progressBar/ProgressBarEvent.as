package com.gotchaslots.common.ui.common.progressBar
{
	import flash.events.Event;
	
	public class ProgressBarEvent extends Event
	{
		// events
		public static const Changed:String = "890c830c7065473185cb25173eb53470";
		public static const ZeroReached:String = "691cf33dbc3d4a159e5c787411e5dd96";
		public static const ValueReached:String = "14f55a8930714711814febf97156da40";
		public static const FullReached:String = "bc5d38d410dc42de9d485e5a6f4b2036";
		
		// members
		private var _percent:Number;
		
		// properties
		public function get Percent():Number
		{
			return _percent;
		}
		
		// class
		public function ProgressBarEvent(type:String, percent:Number = -1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_percent = percent;
		}
	}
}