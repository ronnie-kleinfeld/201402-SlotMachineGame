package com.gotchaslots.slots.ui.machine.bonusGameEngine.base
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.ticker.TickerStateEnumType;
	import com.gotchaslots.slots.data.machine.bonusGame.base.BaseBonusGameData;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class BaseBonusGameEngine extends BasePng
	{
		// members
		protected var _bonusGameData:BaseBonusGameData;
		
		// properties
		protected override function get PngFilters():Array
		{
			return null;
		}
		
		public function get BonusGameData():BaseBonusGameData
		{
			return _bonusGameData;
		}
		
		// class
		public function BaseBonusGameEngine(bonusGameData:BaseBonusGameData)
		{
			_bonusGameData = bonusGameData;
			
			super(800, 446, _bonusGameData.BG);
			
			y = -H;
		}
		public function Init():void
		{
			TweenLite.to(this, 0.5, {y:48});
			Main.Instance.Application.Ticker.Stop();
			Main.Instance.Application.Ticker.TickerStateEnum = TickerStateEnumType.BonusGame;
		}
		
		// methods
		protected function DoBonusGameComplete():void
		{
			Main.Instance.XServices.GoogleAnalytics.TrackBonusGameView(Main.Instance.ActiveMachine.LobbyMachine.ID);
			Main.Instance.Application.Ticker.PushMessage("Bonus Game finished", "", true);
			
			var timer:TimerEx = new TimerEx(1000);
			timer.addEventListener(TimerEvent.TIMER, onDoneTimer);
			timer.start();
		}
		protected function onDoneTimer(event:TimerEvent):void
		{
			var timer:TimerEx = TimerEx(event.currentTarget);
			timer.Dispose();
			timer = null;
			
			_bonusGameData.CalculateChipsWon();
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}