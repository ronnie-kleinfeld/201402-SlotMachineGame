package com.gotchaslots.slots.ui.machine.presentation.strike
{
	import com.gotchaslots.common.assets.machine.MachineEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.valuator.strike.StrikeValuatorData;
	import com.gotchaslots.common.ui.common.components.freeActionScript.pngTrails.PngTrails;
	import com.gotchaslots.slots.ui.machine.SlotsMachineView;
	import com.gotchaslots.slots.ui.machine.presentation.base.BasePresentation;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	
	public class ExtraBigWinPresentation extends BasePresentation
	{
		// properties
		protected override function get ValuatorClass():Class
		{
			return StrikeValuatorData;
		}
		protected override function get IsValuable():Boolean
		{
			return true;
		}
		protected override function get RemoveByTween():Boolean
		{
			return true;
		}
		
		// class
		public function ExtraBigWinPresentation(onClick:Function, onClose:Function, view:SlotsMachineView)
		{
			super(306, onClick, onClose, view);
		}
		
		// methods
		protected override function DoParticle():void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Machine_Sequence_ExtraBigWin_Animation);
			addChild(new PngTrails(MachineEmbed.Star, new Point(350, 354), new Point(325, 250), new Point(200, 100)));
			addChild(new PngTrails(MachineEmbed.Star, new Point(450, 354), new Point(475, 250), new Point(600, 100)));
			DoPostParticle();
		}
		
		protected override function DoPost():void
		{
			Main.Instance.ActiveMachine.Win += _valuatorsHandler.Strike.Chips;
			Main.Instance.Application.Ticker.PushMessage("You Won: " + FormatterHelper.NumberToMoney(Main.Instance.ActiveMachine.Win), "Extra Big Win: +" + FormatterHelper.NumberToMoney(_valuatorsHandler.Strike.Chips), true, 0);
			
			var postTimer:TimerEx = new TimerEx(5000);
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
			
			DoRemove();
		}
	}
}