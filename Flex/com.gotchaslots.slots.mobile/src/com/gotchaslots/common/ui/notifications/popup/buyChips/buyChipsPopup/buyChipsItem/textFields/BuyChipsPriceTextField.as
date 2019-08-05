package com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.buyChipsItem.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class BuyChipsPriceTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.BuyChipsPrice;
		}
		
		// class
		public function BuyChipsPriceTextField(text:String)
		{
			super(112, 34, text);
			
			x = 0;
			y = 34;
		}
	}
}