package com.gotchaslots.common.ui.notifications.popup
{
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.notifications.popup.base.BaseMachinePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.MainPopupButton;
	import com.gotchaslots.common.ui.notifications.popup.buttons.SecondaryPopupButton;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	public class PromptOnClosePopup extends BaseMachinePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Gotcha Slots";
		}
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new SecondaryPopupButton("Quit", OnEndGameClick));
			result.push(new MainPopupButton("Play", OnPlayOnClick));
			return result;
		}
		
		// class
		public function PromptOnClosePopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			AddComponent(new Spacer(20));
			AddBlueMessageTextField(W, "You pressed the");
			AddBlueMessageTextField(W, "quit button!");
		}
		
		// events
		private function OnEndGameClick(event:Event):void
		{
			DoRemove();
			NativeApplication.nativeApplication.exit();
		}
		private function OnPlayOnClick(event:Event):void
		{
			DoRemove();
		}
	}
}