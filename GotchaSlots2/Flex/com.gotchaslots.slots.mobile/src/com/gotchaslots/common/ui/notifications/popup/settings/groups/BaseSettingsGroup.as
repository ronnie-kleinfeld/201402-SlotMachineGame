package com.gotchaslots.common.ui.notifications.popup.settings.groups
{
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	public class BaseSettingsGroup extends BaseClickableButton
	{
		// properties
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		protected override function get HasNormalButton():Boolean
		{
			return true;
		}
		protected override function get NormalButtonColor():Number
		{
			return 0x8330ba;
		}
		protected override function get NormalButtonFrameColor():Number
		{
			return 0x9436ce;
		}
		protected override function get NormalButtonCorner():Number
		{
			return 10;
		}
		
		protected override function get HasSelectedButton():Boolean
		{
			return true;
		}
		protected override function get SelectedButtonColor():Number
		{
			return 0x9436ce;
		}
		protected override function get SelectedButtonFrameColor():Number
		{
			return 0x8330ba;
		}
		protected override function get SelectedButtonCorner():Number
		{
			return 10;
		}
		
		// class
		public function BaseSettingsGroup(w:int, h:int)
		{
			super(w, h, null, "");
		}
	}
}