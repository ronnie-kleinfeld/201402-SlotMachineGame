package com.gotchaslots.slots.ui.machine.bottomPanel.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.SlotsMachineDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class PaylinesValueTextField extends BaseTextField
	{
		// properties
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineBottomPanelPaylinesValue;
		}
		private function get GetText():String
		{
			return FormatterHelper.NumberToMoney(Main.Instance.ActiveMachine.SelectedPaylines, 0);
		}
		
		// class
		public function PaylinesValueTextField()
		{
			super(90, 24, GetText, null, 0x00adf9);
			
			filters = [new GlowFilter(0xEC9EFE, 1, 5, 5)];
			
			Main.Instance.ActiveMachine.addEventListener(SlotsMachineDataEvent.SelectedPaylinesChanged, OnSelectedPaylinesChanged);
		}
		public override function Dispose():void
		{
			Main.Instance.ActiveMachine.addEventListener(SlotsMachineDataEvent.SelectedPaylinesChanged, OnSelectedPaylinesChanged);
			
			super.Dispose();
		}
		
		// events
		protected function OnSelectedPaylinesChanged(event:Event):void
		{
			Text = GetText;
		}
	}
}