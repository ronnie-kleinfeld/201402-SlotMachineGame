package com.gotchaslots.common.utils.xServices.nativeDialogs.inputDialog
{
	import flash.events.Event;

	public class InputDialogEvent extends Event
	{
		// consts
		public static const OK:String = "OK";
		public static const CANCEL:String = "CANCEL";
		
		// members
		private var _input:String;
		
		// properties
		public function get Input():String
		{
			return _input;
		}
		
		// class
		public function InputDialogEvent(type:String, input:String)
		{
			super(type);
			
			_input = input;
		}
	}
}