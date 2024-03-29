package com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	import com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.buttons.TimerBonusDisconnectedButton;
	import com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.buttons.TimerBonusReadyButton;
	import com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.textFields.TimerBonusCountdownTextField;
	import com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.textFields.TimerBonusInitTextField;
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	
	public class TimerBonusPanel extends BaseBG
	{
		// members
		private var _timerBonusDisconnected:TimerBonusDisconnectedButton;
		private var _timerBonusInit:TimerBonusInitTextField;
		private var _timerBonusCountdown:TimerBonusCountdownTextField;
		private var _timerBonusReady:TimerBonusReadyButton;
		
		// properties
		protected override function get BGFilters():Array
		{
			return [new DropShadowFilter(4, 45, 0x000000), new BevelFilter(3, 45, 0xffffff, 1, 0)];
		}
		
		protected override function get FrameCorner():Number
		{
			return 20;
		}
		
		// class
		public function TimerBonusPanel(w:int, h:int)
		{
			super(w, h, 0x9436ce);
			
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusActivated, OnTimerBonusActivated);
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusDeactivated, OnTimerBonusDeactivated);
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusChanged, OnTimerBonusChanged);
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusReady, OnTimerBonusReady);
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.TimerBonusCollected, OnTimerBonusCollected);
			
			if (Main.Instance.Session.Rare.GetIsTimerBonusActive)
			{
				Start();
			}
			else
			{
				ShowDisconnected();
			}
		}
		public override function Dispose():void
		{
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.TimerBonusActivated, OnTimerBonusActivated);
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.TimerBonusDeactivated, OnTimerBonusDeactivated);
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.TimerBonusChanged, OnTimerBonusChanged);
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.TimerBonusReady, OnTimerBonusReady);
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.TimerBonusCollected, OnTimerBonusCollected);
			
			super.Dispose();
		}
		
		// methods
		public function Start():void
		{
			if (_timerBonusCountdown)
			{
				_timerBonusCountdown.Start();
			}
			ShowInit();
		}
		public function Stop():void
		{
			if (_timerBonusCountdown)
			{
				_timerBonusCountdown.Stop();
			}
		}
		
		private function ShowDisconnected():void
		{
			if (!_timerBonusDisconnected)
			{
				_timerBonusDisconnected = new TimerBonusDisconnectedButton(W, H);
				_timerBonusDisconnected.addEventListener(MouseEvent.CLICK, OnTimerBonusDisconnectedButtonClick);
				addChild(_timerBonusDisconnected);
				
				RemoveInit();
				RemoveCountdown();
				RemoveReady();
			}
		}
		private function RemoveDisconnected():void
		{
			if (_timerBonusDisconnected)
			{
				DisplayObjectHelper.SafeRemoveChild(this, _timerBonusDisconnected);
				_timerBonusDisconnected.removeEventListener(MouseEvent.CLICK, OnTimerBonusDisconnectedButtonClick);
				_timerBonusDisconnected.Dispose();
				_timerBonusDisconnected = null;
			}
		}
		
		private function ShowInit():void
		{
			if (!_timerBonusInit)
			{
				if (Main.Instance.Session.Rare.IsTimerBonusReady)
				{
					ShowReady();
				}
				else
				{
					_timerBonusInit = new TimerBonusInitTextField(W, H);
					addChild(_timerBonusInit);
					
					RemoveDisconnected();
					RemoveCountdown();
					RemoveReady();
				}
			}
		}
		private function RemoveInit():void
		{
			if (_timerBonusInit)
			{
				DisplayObjectHelper.SafeRemoveChild(this, _timerBonusInit);
				_timerBonusInit.Dispose();
				_timerBonusInit = null;
			}
		}
		
		private function ShowCountdown():void
		{
			if (!_timerBonusCountdown)
			{
				_timerBonusCountdown = new TimerBonusCountdownTextField(W, H);
				addChild(_timerBonusCountdown);
				
				RemoveDisconnected();
				RemoveInit();
				RemoveReady();
			}
		}
		private function RemoveCountdown():void
		{
			if (_timerBonusCountdown)
			{
				DisplayObjectHelper.SafeRemoveChild(this, _timerBonusCountdown);
				_timerBonusCountdown.Stop();
				_timerBonusCountdown.Dispose();
				_timerBonusCountdown = null;
			}
		}
		
		private function ShowReady():void
		{
			if (!_timerBonusReady)
			{
				_timerBonusReady = new TimerBonusReadyButton(W, H);
				addChild(_timerBonusReady);
				
				RemoveDisconnected();
				RemoveInit();
				RemoveCountdown();
			}
		}
		private function RemoveReady():void
		{
			if (_timerBonusReady)
			{
				DisplayObjectHelper.SafeRemoveChild(this, _timerBonusReady);
				_timerBonusReady.Dispose();
				_timerBonusReady = null;
			}
		}
		
		// events
		protected function OnTimerBonusDisconnectedButtonClick(event:MouseEvent):void
		{
			if (Main.Instance.XServices.InternetTime.IsInternetTime)
			{
				Main.Instance.XServices.InternetTime.UpdateMS();
				ShowInit();
			}
		}
		
		protected function OnTimerBonusActivated(event:Event):void
		{
			ShowInit();
		}
		protected function OnTimerBonusDeactivated(event:Event):void
		{
			ShowDisconnected();
		}
		protected function OnTimerBonusChanged(event:Event):void
		{
			ShowCountdown();
		}
		protected function OnTimerBonusReady(event:Event):void
		{
			ShowReady();
		}
		protected function OnTimerBonusCollected(event:Event):void
		{
			ShowInit();
		}
	}
}