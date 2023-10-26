package com.gotchaslots.common.utils.xServices.nativeDialogs.confirmationDialog
{
	import com.gotchaslots.common.utils.xServices.BaseCoreMobileHandler;
	import com.milkmangames.nativeextensions.CMDialogDispatcher;
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.milkmangames.nativeextensions.events.CMDialogEvent;

	public class ConfirmationDialogHandler extends BaseCoreMobileHandler
	{
		// class
		public function ConfirmationDialogHandler()
		{
			super();
		}
		
		// confirmation dialog
		public function Show(title:String, message:String, buttonLabel:String):void
		{
			if (Init())
			{
				var dialog:CMDialogDispatcher = CoreMobile.mobile.showModalConfirmationDialog(title, message, buttonLabel);
				dialog.addDismissListener(
					function(event:CMDialogEvent):void
					{
						dispatchEvent(new ConfirmationDialogEvent(ConfirmationDialogEvent.OK));
					}
				);
			}
		}
	}
}