package com.gotchaslots.common.ui.notifications.popup.buyChips
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.MainPopupButton;
	
	import flash.events.Event;
	
	public class NoChargePopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Purchase Cancelled!";
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new MainPopupButton("OK", OnOKClick));
			return result;
		}
		
		// class
		public function NoChargePopup(onClose:Function)
		{
			super(onClose);
			
			Main.Instance.XServices.GoogleAnalytics.TrackPurchaseEventShowNoChargePopup();
		}
		protected override function AddBody():void
		{
			AddComponent(new Spacer(16));
			AddBlueMessageTextField(W, "No money was removed");
			AddBlueMessageTextField(W, "from your account");
		}
		
		// events
		private function OnOKClick(event:Event):void
		{
			Main.Instance.XServices.GoogleAnalytics.TrackPurchaseEventOKNoChargePopup(MSSpent);
			DoRemove();
		}
	}
}