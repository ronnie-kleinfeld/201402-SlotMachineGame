package com.gotchaslots.common.ui.notifications.popup.buttons
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	import flash.text.TextField;
	
	public class MainPopupButton extends BaseClickableButton
	{
		// properties
		protected override function get HasNormalButton():Boolean
		{
			return true;
		}
		protected override function get NormalButtonColor():Number
		{
			return 0x05e747;
		}
		protected override function get NormalButtonFrameColor():Number
		{
			return 0x4ba86e;
		}
		
		protected override function get HasSelectedButton():Boolean
		{
			return true;
		}
		protected override function get SelectedButtonColor():Number
		{
			return 0x4ba86e;
		}
		protected override function get SelectedButtonFrameColor():Number
		{
			return 0x05e747;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupButtonMain;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 10;
		}
		
		// class
		public function MainPopupButton(text:String, onClickDispatch:Function)
		{
			super(165, 50, onClickDispatch, text);
		}
	}
}