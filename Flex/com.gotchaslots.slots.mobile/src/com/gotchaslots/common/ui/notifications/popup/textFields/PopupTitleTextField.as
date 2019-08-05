package com.gotchaslots.common.ui.notifications.popup.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public final class PopupTitleTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupTitle;
		}
		
		// class
		public function PopupTitleTextField(w:int, text:String)
		{
			super(w, 40, text);
		}
	}
}