package com.gotchaslots.common.ui.notifications.popup.invite4Chips
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.FacebookInviteButton;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Invite4ChipsPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Welcome back";
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new FacebookInviteButton(OnInviteClick));
			return result;
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function Invite4ChipsPopup(onClose:Function)
		{
			super(onClose);
			
			Main.Instance.Session.Rare.IsInviteAsked = true;
		}
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "Invite your friends");
			AddBlueMessageTextField(W, "and get");
			AddBlueMessageTextField(W, FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelReachedBonusChips, 0) + " Chips");
		}
		
		// events
		private function OnInviteClick(event:Event):void
		{
			SlotsNotificationsHandler.Instance.ShowInviting4ChipsPopup(null);
			Main.Instance.Session.Rare.IsInviteAsked = true;
			DoRemove();
		}
		protected override function OnCloseButtonClick(event:MouseEvent):void
		{
			Main.Instance.Session.Rare.IsInviteAsked = true;
			DoRemove();
		}
	}
}