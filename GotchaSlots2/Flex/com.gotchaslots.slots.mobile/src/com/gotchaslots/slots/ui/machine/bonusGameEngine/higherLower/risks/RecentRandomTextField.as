package com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.risks
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class RecentRandomTextField extends BaseTextField
	{
		// properties
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.BonusGameHigherLowerNextSpin;
		}
		protected override function get TextFieldOffsetY():int
		{
			return -2;
		}
		
		// class
		public function RecentRandomTextField()
		{
			super(60, 66, " ", null, 0x8330ba);
		}
		
		// methods
		public function DoWon(value:int):void
		{
			TweenLite.to(TextField, 0.3, {alpha:0, onComplete:onAlphaComplete, onCompleteParams:[value]});
		}
		
		// events
		private function onAlphaComplete(value:int):void
		{
			Text = FormatterHelper.NumberToMoney(value, 0);
			TweenLite.to(TextField, 0.2, {alpha:1});
		}
	}
}