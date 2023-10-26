package com.gotchaslots.common.ui.notifications.popup.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	import flash.text.TextField;
	
	public class SecondaryPopupButton extends BaseClickableButton
	{
		// properties
		protected override function get HasNormalButton():Boolean
		{
			return true;
		}
		protected override function get NormalButtonColor():Number
		{
			return 0xff01ff;
		}
		protected override function get NormalButtonFrameColor():Number
		{
			return 0xbf5feb;
		}
		
		protected override function get HasSelectedButton():Boolean
		{
			return true;
		}
		protected override function get SelectedButtonColor():Number
		{
			return 0xbf5feb;
		}
		protected override function get SelectedButtonFrameColor():Number
		{
			return 0xff01ff;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupButtonSecondary;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 10;
		}
		
		// class
		public function SecondaryPopupButton(text:String, onClickDispatch:Function)
		{
			super(165, 50, onClickDispatch, text);
		}
	}
}