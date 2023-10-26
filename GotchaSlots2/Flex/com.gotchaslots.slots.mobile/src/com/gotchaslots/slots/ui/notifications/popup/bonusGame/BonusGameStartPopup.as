package com.gotchaslots.slots.ui.notifications.popup.bonusGame
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.MainPopupButton;
	
	import flash.events.Event;
	
	public class BonusGameStartPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Bonus Game!";
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new MainPopupButton("Play", OnPlayClick));
			return result;
		}
		
		protected override function get AutoCloseTimeout():int
		{
			return 0; 
		}
		
		// class
		public function BonusGameStartPopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "You've won a Bonus Game");
			AddComponent(new Spacer(10));
			AddBlueMessageTextField(W, Main.Instance.ActiveMachine.LobbyMachine.BonusGameData.StartPopupMessage);
		}
		
		// events
		private function OnPlayClick(event:Event):void
		{
			DoRemove();
		}
	}
}