package com.gotchaslots.slots.ui.machine.bottomPanel.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class BetHeaderTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineBottomPanelBetHeader;
		}
		protected override function get TextFieldOffsetY():int
		{
			return -5;
		}
		
		// class
		public function BetHeaderTextField()
		{
			super(100, 30, "Bet");
		}
	}
}