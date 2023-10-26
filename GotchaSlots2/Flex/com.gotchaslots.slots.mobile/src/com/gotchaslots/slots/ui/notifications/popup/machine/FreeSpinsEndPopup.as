package com.gotchaslots.slots.ui.notifications.popup.machine
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.common.ui.notifications.popup.base.BaseMachinePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.MainPopupButton;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	
	public class FreeSpinsEndPopup extends BaseMachinePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Congratulations:";
		}
		protected override function get Buttons():Vector.<BaseButton>
		{
			var result:Vector.<BaseButton> = new Vector.<BaseButton>();
			result.push(new MainPopupButton("OK", OnBackToGameClick));
			return result;
		}
		
		// class
		public function FreeSpinsEndPopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "You finished");
			AddBlueMessageTextField(W, Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsWonCount.toString() + " Free Spins");
			AddComponent(new Spacer(16));
			if (Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsChipsSum > 0)
			{
				AddBlueMessageTextField(W, "You Won");
				AddBlueMessageTextField(W, FormatterHelper.NumberToMoney(Main.Instance.ActiveMachine.LobbyMachine.MachineSession.FreeSpinsChipsSum) + " Chips");
			}
		}
		
		// events
		private function OnBackToGameClick(event:Event):void
		{
			DoRemove();
		}
	}
}