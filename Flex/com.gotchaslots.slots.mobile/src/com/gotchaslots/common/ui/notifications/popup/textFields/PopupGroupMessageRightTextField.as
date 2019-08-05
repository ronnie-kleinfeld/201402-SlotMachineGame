package com.gotchaslots.common.ui.notifications.popup.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	public class PopupGroupMessageRightTextField extends BaseTextField
	{
		// properties
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupGroupMessage;
		}
		protected override function get TextFieldOffsetX():int
		{
			return -6;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 60;
		}
		protected override function get Align():String
		{
			return TextFormatAlign.RIGHT;
		}

		// class
		public function PopupGroupMessageRightTextField(w:int, text:String)
		{
			super(w, 30, text);
		}
	}
}