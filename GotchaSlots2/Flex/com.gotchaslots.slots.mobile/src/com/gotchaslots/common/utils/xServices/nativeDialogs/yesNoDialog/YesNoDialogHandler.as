package com.gotchaslots.common.utils.xServices.nativeDialogs.yesNoDialog
{
	import com.gotchaslots.common.utils.xServices.BaseCoreMobileHandler;
	import com.milkmangames.nativeextensions.CMDialogDispatcher;
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.milkmangames.nativeextensions.events.CMDialogEvent;

	public class YesNoDialogHandler extends BaseCoreMobileHandler
	{
		// class
		public function YesNoDialogHandler()
		{
			super();
		}
		
		// yes/no dialog
		public function Show(title:String, message:String, yesButtonLabel:String, noButtonLabel:String):void
		{
			if (Init())
			{
				var dialog:CMDialogDispatcher = CoreMobile.mobile.showModalYesNoDialog(title, message, yesButtonLabel, noButtonLabel);
				dialog.addDismissListener(
					function(event:CMDialogEvent):void
					{
						switch (event.selectedButtonLabel)
						{
							case yesButtonLabel:
								dispatchEvent(new YesNoDialogEvent(YesNoDialogEvent.YES));
								break;
							case noButtonLabel:
								dispatchEvent(new YesNoDialogEvent(YesNoDialogEvent.NO));
								break;
							default:
								dispatchEvent(new YesNoDialogEvent(YesNoDialogEvent.NO));
								break;
						}
					}
				);
			}
		}
	}
}