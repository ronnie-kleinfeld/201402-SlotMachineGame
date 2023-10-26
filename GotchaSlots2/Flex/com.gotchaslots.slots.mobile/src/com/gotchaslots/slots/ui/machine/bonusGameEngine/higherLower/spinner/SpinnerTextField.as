package com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.spinner
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.text.TextField;
	
	public class SpinnerTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.BonusGameHigherLowerSpinner;
		}
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		// class
		public function SpinnerTextField(random:int)
		{
			super(100, 100, FormatterHelper.NumberToMoney(random, 0));
		}
	}
}