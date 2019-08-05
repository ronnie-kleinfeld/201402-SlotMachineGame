package com.gotchaslots.slots.ui.machine.freeSpins
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.text.TextField;
	
	public class BubblingFreeSpinsTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineFreeSpinsRibbonBubbling;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 60;
		}
	
		// class
		public function BubblingFreeSpinsTextField()
		{
			super(50, 30, "Bubbling");
		}
	}
}