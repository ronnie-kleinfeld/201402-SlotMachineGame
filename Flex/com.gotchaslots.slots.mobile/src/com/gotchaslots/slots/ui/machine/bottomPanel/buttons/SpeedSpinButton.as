package com.gotchaslots.slots.ui.machine.bottomPanel.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseSwitchableButton;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SpeedSpinButton extends BaseSwitchableButton
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.MachineBottomPanelSpeed;
		}
		
		protected override function get HasNormalButton():Boolean
		{
			return true;
		}
		protected override function get NormalButtonColor():Number
		{
			return 0x0096ff;
		}
		protected override function get NormalButtonFrameColor():Number
		{
			return 0x00adf9;
		}
		protected override function get NormalButtonCorner():Number
		{
			return width * .4;
		}
		
		protected override function get HasSelectedButton():Boolean
		{
			return true;
		}
		protected override function get SelectedButtonColor():Number
		{
			return 0x00adf9;
		}
		protected override function get SelectedButtonFrameColor():Number
		{
			return 0x0096ff;
		}
		protected override function get SelectedButtonCorner():Number
		{
			return width * .4;
		}
		
		// class
		public function SpeedSpinButton()
		{
			super(90, 60, null, "Fast", "Slow");
		}
		
		// events
		protected override function OnNormal(event:MouseEvent):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Machine_BottomPanel_Speed_Fast);
			Main.Instance.ActiveMachine.IsSpeedSpin = false;
		}
		protected override function OnSelected(event:MouseEvent):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.Machine_BottomPanel_Speed_Slow);
			Main.Instance.ActiveMachine.IsSpeedSpin = true;
		}
	}
}