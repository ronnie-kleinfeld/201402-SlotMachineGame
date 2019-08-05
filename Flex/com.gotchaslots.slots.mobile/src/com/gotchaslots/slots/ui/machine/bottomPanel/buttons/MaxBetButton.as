package com.gotchaslots.slots.ui.machine.bottomPanel.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.ui.machine.bottomPanel.BottomPanelEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MaxBetButton extends BaseBottomPanelButton
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineBottomPanelMaxBet;
		}
		
		// class
		public function MaxBetButton()
		{
			super(100, 100, "Max\nBet");
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			super.OnClick(event);
			dispatchEvent(new Event(BottomPanelEvent.MaxBetButtonClicked));
		}
	}
}