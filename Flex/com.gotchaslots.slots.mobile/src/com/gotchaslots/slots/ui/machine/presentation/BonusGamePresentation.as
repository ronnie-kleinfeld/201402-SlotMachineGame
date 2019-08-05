package com.gotchaslots.slots.ui.machine.presentation
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.ticker.TickerStateEnumType;
	import com.gotchaslots.slots.data.machine.valuator.bonusGame.BonusGameValuatorData;
	import com.gotchaslots.slots.data.machine.valuator.bonusGame.BonusGameValuatorsData;
	import com.gotchaslots.common.ui.common.components.Flipper2;
	import com.gotchaslots.slots.ui.machine.SlotsMachineView;
	import com.gotchaslots.slots.ui.machine.Symbol;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.base.BaseBonusGameEngine;
	import com.gotchaslots.slots.ui.machine.presentation.base.BaseScatterPresentation;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class BonusGamePresentation extends BaseScatterPresentation
	{
		// members
		private var _bonusGameEngine:BaseBonusGameEngine;
		
		// properties
		protected override function get ValuatorClass():Class
		{
			return BonusGameValuatorsData;
		}
		
		// class
		public function BonusGamePresentation(onClick:Function, onClose:Function, view:SlotsMachineView)
		{
			super(446, onClick, onClose, view);
		}
		
		// methods
		protected override function DoFlipper2():void
		{
			var paylinePainted:Boolean;
			
			var flipper2:Flipper2;
			for (var i:int = 0; i < _valuatorsHandler.BonusGame.BonusGameValuators.length; i++)
			{
				var bonusGameValuator:BonusGameValuatorData = _valuatorsHandler.BonusGame.BonusGameValuators[i];
				if (bonusGameValuator.IsValuable)
				{
					if (!paylinePainted)
					{
						var payline:Bitmap = bonusGameValuator.Payline.PaylineReelsPng;
						payline.y = 48;
						addChild(payline);
						paylinePainted = true;
					}
					
					for (var j:int = 0; j < bonusGameValuator.Payboxes.length; j++)
					{
						var symbol:Symbol = Main.Instance.ActiveMachine.LobbyMachine.Symbols.BonusGameSymbol.GetSymbol(bonusGameValuator.Payboxes[j].Rect);
						symbol.x = bonusGameValuator.Payboxes[j].Rect.x;
						symbol.y = bonusGameValuator.Payboxes[j].Rect.y + 48;
						addChild(symbol);
						
						flipper2 = new Flipper2(150, 10, Main.Instance.ActiveMachine.LobbyMachine.PayboxFramePngs);
						flipper2.x = -2 + bonusGameValuator.Payboxes[j].Rect.x;
						flipper2.y = -2 + bonusGameValuator.Payboxes[j].Rect.y + 48;
						
						addChild(flipper2);
						flipper2.Start();
					}
				}
			}
			
			var postTimer:TimerEx = new TimerEx(2000);
			postTimer.addEventListener(TimerEvent.TIMER, OnPostTimer);
			postTimer.start();
		}
		private function OnPostTimer(event:TimerEvent):void
		{
			var postTimer:TimerEx = TimerEx(event.currentTarget);
			if (postTimer)
			{
				postTimer.Dispose();
				postTimer = null;
			}
			
			DoPostFlipper2();
		}
		
		protected override function DoPostFlipper2():void
		{
			DoStartBonusGameEngine();
		}
		private function DoStartBonusGameEngine():void
		{
			Main.Instance.ActiveMachine.LobbyMachine.BonusGameData = null;
			_bonusGameEngine = new Main.Instance.ActiveMachine.LobbyMachine.BonusGameData.BonusGameEngineClass(Main.Instance.ActiveMachine.LobbyMachine.BonusGameData);
			_bonusGameEngine.addEventListener(Event.COMPLETE, onBaseBonusGameEngineComplete);
			SlotsMachineView(_view).GetPresentationBox.addChild(_bonusGameEngine);
			_bonusGameEngine.Init();
			
			SlotsNotificationsHandler.Instance.ShowBonusGameStartPopup(null);
		}
		protected function onBaseBonusGameEngineComplete(event:Event):void
		{
			_bonusGameEngine = BaseBonusGameEngine(event.currentTarget);
			_bonusGameEngine.removeEventListener(Event.COMPLETE, onBaseBonusGameEngineComplete);
			_valuatorsHandler.BonusGame.Chips = _bonusGameEngine.BonusGameData.Chips;
			DoBonusGameEndPopup(_valuatorsHandler.BonusGame.Chips);
		}
		private function DoBonusGameEndPopup(chips:Number):void
		{
			if (chips == 0)
			{
				DoPostBonusGameEndPopup();
			}
			else
			{
				SlotsNotificationsHandler.Instance.ShowBonusGameEndPopup(chips, DoPostBonusGameEndPopup);
				Main.Instance.XServices.Social.ShareBonusGame(chips);
			}
		}
		private function DoPostBonusGameEndPopup():void
		{
			Main.Instance.Application.Ticker.TickerStateEnum = TickerStateEnumType.Machine;
			Main.Instance.Application.Ticker.Start();
			DisplayObjectHelper.SafeDisposeChild(SlotsMachineView(_view).GetPresentationBox, _bonusGameEngine);
			DoParticle();
		}
	}
}