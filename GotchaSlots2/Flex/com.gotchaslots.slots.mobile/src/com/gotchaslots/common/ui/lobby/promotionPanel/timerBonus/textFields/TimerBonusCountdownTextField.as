package com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	public class TimerBonusCountdownTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.LobbyTimerBonusCountdown;
		}
		private function get GetText():String
		{
			return "Timer Bonus\nCountdown\n" + Main.Instance.Session.Rare.TimerBonusLeft;
		}
		
		// class
		public function TimerBonusCountdownTextField(w:int, h:int)
		{
			super(w, h, GetText);
			
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusChanged, OnTimerBonusChanged);
		}
		
		// methods
		public function Start():void
		{
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusChanged, OnTimerBonusChanged);
		}
		public function Stop():void
		{
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.TimerBonusChanged, OnTimerBonusChanged);
		}
		
		// events
		protected function OnTimerBonusChanged(event:Event):void
		{
			Text = GetText; 
		}
	}
}