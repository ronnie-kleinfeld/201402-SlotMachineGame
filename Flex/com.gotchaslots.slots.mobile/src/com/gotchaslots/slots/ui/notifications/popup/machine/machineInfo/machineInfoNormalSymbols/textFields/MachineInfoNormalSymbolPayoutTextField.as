package com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoNormalSymbols.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class MachineInfoNormalSymbolPayoutTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineInfoNormalSymbolPayout;
		}
		
		// class
		public function MachineInfoNormalSymbolPayoutTextField(w:int, h:int, text:String)
		{
			super(w, h, text);
		}
	}
}