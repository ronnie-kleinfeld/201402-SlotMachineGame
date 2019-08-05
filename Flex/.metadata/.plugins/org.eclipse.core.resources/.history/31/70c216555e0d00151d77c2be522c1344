package com.gotchaslots.common.data.application.ticker
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class CommonTickerData extends EventDispatcherEx
	{
		// members
		private var _tickerStateEnum:String;
		private var _messages:Vector.<String>;
		protected var _randomMessages:Vector.<String>;
		private var _timer:TimerEx;
		
		// properties
		public function get TickerStateEnum():String
		{
			return _tickerStateEnum;
		}
		public function set TickerStateEnum(value:String):void
		{
			if (_tickerStateEnum != value)
			{
				_tickerStateEnum = value;
				switch (_tickerStateEnum)
				{
					case TickerStateEnumType.Lobby:
						dispatchEvent(new TickerDataEvent(TickerDataEvent.StateLobby, "", ""));
						break;
					case TickerStateEnumType.Machine:
						dispatchEvent(new TickerDataEvent(TickerDataEvent.StateMachine, "", ""));
						break;
					case TickerStateEnumType.BonusGame:
						dispatchEvent(new TickerDataEvent(TickerDataEvent.StateBonusGame, "", ""));
						break;
					default:
						dispatchEvent(new TickerDataEvent(TickerDataEvent.StateLobby, "", ""));
						break;
				}
			}
		}
		
		public function get Message():String
		{
			var result:String;
			
			if (_messages && _messages.length > 0)
			{
				result = _messages[0];
				_messages.splice(0, 1);
			}
			else
			{
				result = _randomMessages[Math.floor(Math.random() * _randomMessages.length)];
			}
			
			return result;
		}
		
		// class
		public function CommonTickerData()
		{
			TickerStateEnum = TickerStateEnumType.Lobby;
			
			_messages = new Vector.<String>();
			
			InitRandomMessages();
			
			_timer = new TimerEx(3000);
			_timer.addEventListener(TimerEvent.TIMER, OnTimer);
			_timer.stop();
		}
		protected function InitRandomMessages():void
		{
			throw new MustOverrideError();
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			if (_timer)
			{
				_timer.Dispose();
				_timer = null;
			}
			
			DisposeMessages();
			
			while (_randomMessages && _randomMessages.length > 0)
			{
				_randomMessages.pop();
			}
			_randomMessages = null;
		}
		private function DisposeMessages():void
		{
			while (_messages && _messages.length > 0)
			{
				_messages.pop();
			}
			_messages = null;
		}
		
		// methods
		public function Start():void
		{
			if (_timer && !_timer.running && Main.Instance.Application && Main.Instance.Application.EnableTicker)
			{
				_timer.start();
				Show(Message, "");
			}
		}
		public function Stop():void
		{
			if (_timer)
			{
				_timer.stop();
			}
			DisposeMessages();
		}
		public function PushMessage(message:String, bubble:String, showNow:Boolean, wait:int = 0):void
		{
			if (message != "")
			{
				if (showNow)
				{
					ShowLater(message, bubble, wait);
				}
				else
				{
					if (_messages)
					{
						_messages.push(message);
					}
					else
					{
						ShowLater(message, bubble, wait);
					}
				}
			}
		}
		private function ShowLater(message:String, bubble:String, wait:int):void
		{
			if (wait > 0)
			{
				var sprite:SpriteEx = new SpriteEx();
				TweenLite.to(sprite, wait / 1000, {x:100, onComplete:OnShowLaterComplete, onCompleteParams:[message, bubble]});
			}
			else
			{
				Show(message, bubble);
			}
		}
		private function OnShowLaterComplete(message:String, bubble:String):void
		{
			Show(message, bubble);
		}
		
		private function Show(message:String, bubble:String):void
		{
			dispatchEvent(new TickerDataEvent(TickerDataEvent.TextChanged, message, bubble));
		}
		
		// events
		protected function OnTimer(event:Event):void
		{
			Show(Message, "");
		}
	}
}