package com.gotchaslots.common.utils.xServices.nativeDialogs.pickerDialog
{
	import com.gotchaslots.common.utils.xServices.BaseCoreMobileHandler;
	import com.milkmangames.nativeextensions.CMPickerDispatcher;
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.milkmangames.nativeextensions.events.CMPickerEvent;

	public class PickerDialogHandler extends BaseCoreMobileHandler
	{
		// class
		public function PickerDialogHandler()
		{
			super();
		}
		
		// picker dialog
		public function Show(items:Vector.<String>, selectedIndex:int = 0, doneLabel:String = "Done", cancelLabel:String = "Cancel", popOverX:Number = 320, popOverY:Number = 320):void
		{
			if (Init())
			{
				//var items:Vector.<String>=new <String>["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eigth", "Ninth", "Tenth", "Eleventh"];
				// 'items' is the list of items, defined above, to present in the picker
				// '3' is the default index of the item to pre-select
				// “Done” and “Cancel” allow you to specify the button labels to use on Android. On iOS it will use the
				// system default buttons for these functions.
				//
				// On iOS iPads, the picker is presented in a popover bubble.
				// 320, 320 is the location in device POINTS (not pixels!) where the popover will originate from.
				var dialog:CMPickerDispatcher = CoreMobile.mobile.showPicker(items, selectedIndex, doneLabel, cancelLabel, popOverX, popOverY);
				dialog.addDismissListener(
					function(event:CMPickerEvent):void
					{
						if (event.wasCanceled)
						{
							dispatchEvent(new PickerDialogEvent(PickerDialogEvent.CANCELED, items, event.selectedItemIndex));
						}
						else
						{
							dispatchEvent(new PickerDialogEvent(PickerDialogEvent.SELECTED, items, event.selectedItemIndex));
						}
					}
				);
			}
		}
		public function Cancel():void
		{
			CoreMobile.mobile.cancelPicker();
		}
	}
}