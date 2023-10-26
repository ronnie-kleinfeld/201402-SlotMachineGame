package com.gotchaslots.common.ui.notifications.popup.level
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.textFields.PopupGroupMessageLeftTextField;
	import com.gotchaslots.common.ui.notifications.popup.textFields.PopupGroupMessageRightTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	
	public class LevelInfoPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.BigPopup;
		}
		
		protected override function get Title():String
		{
			return "Level Info";
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function LevelInfoPopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			AddLevelTextField(0, "This Level:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelNumber, 0, 0));
			AddLevelTextField(1, "XP Range:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.MinXP, 0, 0) + "-" + FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.NextMinXP - 1));
			AddLevelTextField(2, "Level Up Bonus:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelReachedBonusChips, 0));
			AddLevelTextField(3, "Timer Bonus:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.TimerBonusChips));
			AddLevelTextField(4, "Max Bet:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.MaxBetLevelChips.Chips));
			AddLevelTextField(5.2, "Next Level:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.LevelNumber + 1, 0, 0));
			AddLevelTextField(6.2, "XP for Next Level:", FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.NextMinXP));
		}
		
		// methods
		private function AddLevelTextField(index:Number, label:String, value:String):void
		{
			var labelTextField:PopupGroupMessageLeftTextField = new PopupGroupMessageLeftTextField(W * 0.9, label);
			labelTextField.x = W * 0.05;
			labelTextField.y = index * 36 + 40;
			addChild(labelTextField);
			
			var valueTextField:PopupGroupMessageRightTextField = new PopupGroupMessageRightTextField(W * 0.9, value);
			valueTextField.x = W * 0.05;
			valueTextField.y = index * 36 + 40;
			addChild(valueTextField);
		}
		
		// events
		private function OnCloseClick(event:Event):void
		{
			DoRemove();
		}
	}
}