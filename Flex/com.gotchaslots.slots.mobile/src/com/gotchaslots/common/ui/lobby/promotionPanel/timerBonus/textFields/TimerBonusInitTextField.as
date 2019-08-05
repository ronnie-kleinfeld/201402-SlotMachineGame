package com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class TimerBonusInitTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.LobbyTimerBonusInit;
		}
		
		// class
		public function TimerBonusInitTextField(w:int, h:int)
		{
			super(w, h, "Checking your\nTimer Bonus\nStatus");
		}
	}
}