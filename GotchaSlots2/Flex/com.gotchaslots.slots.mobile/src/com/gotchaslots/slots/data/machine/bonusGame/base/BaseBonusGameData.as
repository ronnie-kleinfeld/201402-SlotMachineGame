package com.gotchaslots.slots.data.machine.bonusGame.base
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.SlotsMachineData;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.common.utils.numberTimer.NumberTimer;
	import com.gotchaslots.common.utils.numberTimer.NumberTimerEvent;
	
	import flash.display.Bitmap;
	
	public class BaseBonusGameData extends EventDispatcherEx
	{
		// members
		private var _activeMachine:SlotsMachineData;
		private var _bg:Bitmap;
		private var _chips:Number;
		private var _chipsNumberTimer:NumberTimer;
		
		// properties
		public function get StartPopupMessage():String
		{
			throw new MustOverrideError();
		}
		public function get BonusGameEngineClass():Class
		{
			throw new MustOverrideError();
		}
		
		protected function get BGClass():Class
		{
			throw new MustOverrideError();
		}
		public function get BG():Bitmap
		{
			if (BGClass && !_bg)
			{
				_bg = new BGClass();
			}
			else
			{
				_bg = new Bitmap();
			}
			return _bg;
		}
		
		public function get Chips():Number
		{
			return _chips;
		}
		public function set Chips(value:Number):void
		{
			if (_chips != value)
			{
				_chipsNumberTimer.NumberTo(_chips, value);
				_chips = value;
			}
		}
		
		// class
		public function BaseBonusGameData()
		{
			super();
			
			_chipsNumberTimer = new NumberTimer();
			_chipsNumberTimer.addEventListener(NumberTimerEvent.Changed, OnChipsNumberTimerChanged);
			
			_activeMachine = Main.Instance.ActiveMachine;
			_chips = 0;
		}
		public override function Dispose():void
		{
			if (_chipsNumberTimer)
			{
				_chipsNumberTimer.Dispose();
				_chipsNumberTimer = null;
			}
		}
		
		// methods
		public function CalculateChipsWon():void
		{
			throw new MustOverrideError();
		}
		
		// events
		protected function OnChipsNumberTimerChanged(event:NumberTimerEvent):void
		{
			dispatchEvent(new BonusGameDataEvent(BonusGameDataEvent.ChipsChanged, event.Value));
		}
	}
}