package com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.machineInfoPaylines.textField
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class MachineInfoPaylineTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineInfoPayline;
		}
		
		// class
		public function MachineInfoPaylineTextField(text:String)
		{
			super(50, 50, text);
		}
	}
}