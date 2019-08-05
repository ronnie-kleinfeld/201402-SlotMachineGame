package com.gotchaslots.common.ui.notifications.popup
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.textFields.PopupBlueMessageTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	
	public class JackpotInfoPopup extends BasePopup
	{
		// members
		private var _chips:PopupBlueMessageTextField;
		
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		protected override function get Y():int
		{
			return 88;
		}
		
		protected override function get Title():String
		{
			return "Jackpot";
		}
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function JackpotInfoPopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			_chips = new PopupBlueMessageTextField(W, FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetJackpot, 0));
			Main.Instance.Session.Wallet.addEventListener(SessionDataEvent.JackpotChanged, OnJackpotChanged);
			AddComponent(new Spacer(10));
			AddBlueMessageTextField(W, "Jackpot Value");
			AddComponent(_chips);
			AddBlueMessageTextField(W, "Chips");
			AddComponent(new Spacer(10));
			AddBlueMessageTextField(W, "Keep playing to");
			AddBlueMessageTextField(W, "Increase your chance");
		}
		
		// events
		protected function OnJackpotChanged(event:Event):void
		{
			_chips.Text = FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetJackpot, 0);
		}
		
		private function OnCloseClick(event:Event):void
		{
			DoRemove();
		}
	}
}