package com.gotchaslots.slots.ui.machine.reelsPanel
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.SlotsMachineDataEvent;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.common.utils.helpers.DisplayObjectHelper;
	
	import flash.events.Event;
	
	public class PaylinesBox extends BaseComponent
	{
		// class
		public function PaylinesBox()
		{
			super(800, 306);
			
			Main.Instance.ActiveMachine.addEventListener(SlotsMachineDataEvent.SelectedPaylinesChanged, OnSelectedPaylinesChanged);
		}
		public override function Dispose():void
		{
			super.Dispose();
			Main.Instance.ActiveMachine.removeEventListener(SlotsMachineDataEvent.SelectedPaylinesChanged, OnSelectedPaylinesChanged);
		}
		
		// methods
		public function Stop():void
		{
			while (numChildren > 1)
			{
				DisplayObjectHelper.SafeRemoveChildAt(this, 1);
			}
		}
		
		// events
		protected function OnSelectedPaylinesChanged(event:Event):void
		{
			DisplayObjectHelper.SafeRemoveChildAt(this, 1);
			
			var payline:BasePaylineData = Main.Instance.ActiveMachine.LobbyMachine.Paylines.Paylines[Main.Instance.ActiveMachine.SelectedPaylines - 1];
			
			var png:BasePng = new BasePng(800, 306, payline.PaylineReelsPng);
			addChild(png);
		}
	}
}