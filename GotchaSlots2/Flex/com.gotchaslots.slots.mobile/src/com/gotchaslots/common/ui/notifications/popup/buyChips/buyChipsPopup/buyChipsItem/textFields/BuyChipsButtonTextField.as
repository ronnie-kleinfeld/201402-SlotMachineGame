package com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class BuyChipsButtonTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.BuyChipsButton;
		}
		
		// class
		public function BuyChipsButtonTextField(text:String)
		{
			super(112, 37, text);
			
			x = 0;
			y = 150;
		}
	}
}