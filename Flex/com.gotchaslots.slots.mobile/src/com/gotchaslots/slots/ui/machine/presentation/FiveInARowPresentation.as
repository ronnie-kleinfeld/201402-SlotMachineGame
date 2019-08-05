package com.gotchaslots.slots.ui.machine.presentation
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.valuator.strike.StrikeValuatorData;
	import com.gotchaslots.common.ui.common.components.stardust.sparkText.SparkText;
	import com.gotchaslots.slots.ui.machine.SlotsMachineView;
	import com.gotchaslots.slots.ui.machine.presentation.base.BasePresentation;
	import com.gotchaslots.common.utils.ex.TimerEx;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.TimerEvent;
	
	public class FiveInARowPresentation extends BasePresentation
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
		public function FiveInARowPresentation(onClick:Function, onClose:Function, view:SlotsMachineView)
		{
			super(306, onClick, onClose, view);
		}
		
		// methods
		protected override function DoParticle():void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Machine_Sequence_FiveInARow_Animation);
//			var sparkText:SparkText = new SparkText(new SparkTextAnimationHandler._text5());
//			sparkText.x = 198;
//			sparkText.y = 150;
//			addChild(sparkText);
			DoPostParticle();
		}
		
		protected override function DoPost():void
		{
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
			
			DoRemove();
		}
	}
}