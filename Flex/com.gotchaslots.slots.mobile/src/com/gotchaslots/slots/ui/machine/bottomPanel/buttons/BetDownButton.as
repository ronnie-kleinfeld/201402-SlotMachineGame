package com.gotchaslots.slots.ui.machine.bottomPanel.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BetDownButton extends BaseBottomPanelButton
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineBottomPanelBetButton;
		}
		protected override function get TextFieldOffsetY():int
		{
			return 2;
		}
		
		// class
		public function BetDownButton()
		{
			super(40, 40, "-");
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			super.OnClick(event);
			Main.Instance.Sounds.Play(SlotsSoundsManager.Down);
			Main.Instance.ActiveMachine.SelectedBetIndex--;
		}
	}
}