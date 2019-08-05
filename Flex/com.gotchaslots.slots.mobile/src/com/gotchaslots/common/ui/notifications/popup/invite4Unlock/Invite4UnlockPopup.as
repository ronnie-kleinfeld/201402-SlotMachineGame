package com.gotchaslots.common.ui.notifications.popup.invite4Unlock
{
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.common.ui.common.components.base.BaseButton;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.buttons.FacebookInviteButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Invite4UnlockPopup extends BasePopup
	{
		// members
		private var _lobbyMachine:SlotsBaseLobbyMachineData;
		
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.MediumPopup;
		}
		
		protected override function get Title():String
		{
			return "Unlock";
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
		public function Invite4UnlockPopup(lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function)
		{
			super(onClose);
			
			_lobbyMachine = lobbyMachine;
		}
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "Invite your friends");
			AddBlueMessageTextField(W, "to unlock this");
			AddBlueMessageTextField(W, "slot machine");
		}
		
		// events
		private function OnInviteClick(event:Event):void
		{
			SlotsNotificationsHandler.Instance.ShowInviting4UnlockPopup(_lobbyMachine, null);
			DoRemove();
		}
		protected override function OnCloseButtonClick(event:MouseEvent):void
		{
			DoRemove();
		}
	}
}