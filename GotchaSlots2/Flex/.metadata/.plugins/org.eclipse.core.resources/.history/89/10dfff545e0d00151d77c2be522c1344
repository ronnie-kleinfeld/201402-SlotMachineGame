package com.gotchaslots.common.ui.notifications.popup.settings.textField
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class PopupSettingsTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupSettings;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 50;
		}

		// class
		public function PopupSettingsTextField(w:int, text:String)
		{
			super(w, 40, text);
		}
	}
}