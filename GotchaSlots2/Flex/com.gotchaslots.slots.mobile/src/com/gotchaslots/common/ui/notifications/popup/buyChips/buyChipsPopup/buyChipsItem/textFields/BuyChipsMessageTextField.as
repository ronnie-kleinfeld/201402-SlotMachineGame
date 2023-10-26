package com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class BuyChipsMessageTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.BuyChipsMessage;
		}
		
		// class
		public function BuyChipsMessageTextField(text:String)
		{
			super(112, 68, text);
			
			x = 0;
			y = 82;
		}
	}
}