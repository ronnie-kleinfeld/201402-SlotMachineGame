package com.gotchaslots.common.ui.notifications.popup
{
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.MainPopupButton;
	
	import flash.events.Event;
	
	public class NoConnectionPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "No Connection!";
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new MainPopupButton("Retry", OnRetryClick));
			return result;
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function NoConnectionPopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "No internet");
			AddBlueMessageTextField(W, "connection");
			AddComponent(new Spacer(6));
			AddBlueMessageTextField(W, "Please check your");
			AddBlueMessageTextField(W, "internet connection");
			AddBlueMessageTextField(W, "and retry");
		}
		
		// events
		private function OnCloseClick(event:Event):void
		{
			DoRemove();
		}
		private function OnRetryClick(event:Event):void
		{
			DoRemove();
		}
	}
}