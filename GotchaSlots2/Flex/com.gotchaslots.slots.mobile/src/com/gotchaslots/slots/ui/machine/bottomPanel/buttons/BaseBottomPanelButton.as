package com.gotchaslots.slots.ui.machine.bottomPanel.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	import flash.events.MouseEvent;
	
	public class BaseBottomPanelButton extends BaseClickableButton
	{
		// properties
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
		public function BaseBottomPanelButton(w:int, h:int, text:String)
		{
			super(w, h, null, text);
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			Main.Instance.ActiveMachine.IsAutoSpin = false;
			super.OnClick(event);
		}
	}
}