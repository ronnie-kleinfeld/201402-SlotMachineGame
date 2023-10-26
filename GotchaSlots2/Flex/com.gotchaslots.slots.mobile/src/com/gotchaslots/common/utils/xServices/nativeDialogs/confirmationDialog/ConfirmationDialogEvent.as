package com.gotchaslots.common.utils.xServices.nativeDialogs.confirmationDialog
{
	import flash.events.Event;

	public class ConfirmationDialogEvent extends Event
	{
		// consts
		public static const OK:String = "OK";
		
		// class
		public function ConfirmationDialogEvent(type:String)
		{
			super(type);
		}
	}
}