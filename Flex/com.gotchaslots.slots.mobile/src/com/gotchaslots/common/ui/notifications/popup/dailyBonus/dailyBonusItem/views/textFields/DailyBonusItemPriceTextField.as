package com.gotchaslots.common.ui.notifications.popup.dailyBonus.dailyBonusItem.views.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class DailyBonusItemPriceTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.DailyBonusPrice;
		}
		
		// class
		public function DailyBonusItemPriceTextField(text:String)
		{
			super(119, 59, text);
			
			x = 0;
			y = 95;
		}
	}
}