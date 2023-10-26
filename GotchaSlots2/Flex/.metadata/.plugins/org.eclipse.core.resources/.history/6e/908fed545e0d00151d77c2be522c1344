package com.gotchaslots.common.ui.notifications
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.prices.PriceOptionData;
	import com.gotchaslots.common.data.session.level.LevelData;
	import com.gotchaslots.common.ui.notifications.base.BaseNotification;
	import com.gotchaslots.common.ui.notifications.popup.ErrorPopup;
	import com.gotchaslots.common.ui.notifications.popup.JackpotInfoPopup;
	import com.gotchaslots.common.ui.notifications.popup.NewMachinePopup;
	import com.gotchaslots.common.ui.notifications.popup.NoConnectionPopup;
	import com.gotchaslots.common.ui.notifications.popup.PromptOnClosePopup;
	import com.gotchaslots.common.ui.notifications.popup.WelcomePopup;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.BuyingChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.ChipsBoughtPopup;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.NoChargePopup;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.buyChipsPopup.BuyChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.connect.ConnectPopup;
	import com.gotchaslots.common.ui.notifications.popup.connect.ConnectingPopup;
	import com.gotchaslots.common.ui.notifications.popup.connect.LoggedOnPopup;
	import com.gotchaslots.common.ui.notifications.popup.dailyBonus.DailyBonusPopup;
	import com.gotchaslots.common.ui.notifications.popup.invite4Chips.Invite4ChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.invite4Chips.Invited4ChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.invite4Chips.Inviting4ChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.invite4Unlock.Invite4UnlockPopup;
	import com.gotchaslots.common.ui.notifications.popup.invite4Unlock.Invited4UnlockPopup;
	import com.gotchaslots.common.ui.notifications.popup.invite4Unlock.Inviting4UnlockPopup;
	import com.gotchaslots.common.ui.notifications.popup.level.LevelInfoPopup;
	import com.gotchaslots.common.ui.notifications.popup.level.LevelUpPopup;
	import com.gotchaslots.common.ui.notifications.popup.machine.LowChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.machine.NoChipsBuyChipsPopup;
	import com.gotchaslots.common.ui.notifications.popup.settings.SettingsPopup;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.slots.data.lobby.lobbyMachine.base.SlotsBaseLobbyMachineData;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.slots.ui.notifications.popup.machine.machineInfo.SlotsMachineInfoPopup;
	
	import flash.events.UncaughtErrorEvent;

	public class CommonNotificationsHandler extends EventDispatcherEx
	{
		// members
		protected var _notificationsPanel:NotificationsPanel;
		
		// properties
		public function get ShowingNotifications():Boolean
		{
			return (_notificationsPanel.numChildren > 0);
		}
		public function get NotificationType():BaseNotification
		{
			if (ShowingNotifications)
			{
				return BaseNotification(_notificationsPanel.getChildAt(0));
			}
			else
			{
				return null;
			}
		}
		
		// class
		public function CommonNotificationsHandler()
		{
			super();
		}
		public function Init(notificationsPanel:NotificationsPanel):void
		{
			_notificationsPanel = notificationsPanel;
			
			Main.Instance.Device.DeviceStage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, OnUncaughtError);
		}
		
		// methods
		public function RemoveNotification():void
		{
			_notificationsPanel.RemoveNotifications();
		}
		
		// events
		protected function OnUncaughtError(event:UncaughtErrorEvent):void
		{
			SlotsNotificationsHandler.Instance.ShowErrorPopup("UncaughtErrorEvent:" + event.error.toString(), null);
		}
		
		// popups
		public function ShowBuyChipsPopup(onlyCurrent:Boolean, onClose:Function):void
		{
			_notificationsPanel.Push(new BuyChipsPopup(onlyCurrent, onClose), true);
		}
		public function ShowBuyingChipsPopup(priceOption:PriceOptionData, onClose:Function):void
		{
			_notificationsPanel.Push(new BuyingChipsPopup(priceOption, onClose), true);
		}
		public function ShowChipsBoughtPopup(priceOption:PriceOptionData, onClose:Function):void
		{
			_notificationsPanel.Push(new ChipsBoughtPopup(priceOption, onClose), true);
		}
		public function ShowNoChargePopup(onClose:Function):void
		{
			_notificationsPanel.Push(new NoChargePopup(onClose), true);
		}
		public function ShowConnectingPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new ConnectingPopup(onClose), true);
		}
		public function ShowConnectPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new ConnectPopup(onClose), true);
		}
		public function ShowDailyBonusPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new DailyBonusPopup(onClose), true);
		}
		public function ShowErrorPopup(errorMessage:String, onClose:Function):void
		{
			_notificationsPanel.Push(new ErrorPopup(errorMessage, onClose), true);
		}
		
		public function ShowInvite4ChipsPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new Invite4ChipsPopup(onClose), true);
		}
		public function ShowInviting4ChipsPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new Inviting4ChipsPopup(onClose), true);
		}
		public function ShowInvited4ChipsPopup(count:int):void
		{
			_notificationsPanel.Push(new Invited4ChipsPopup(count), true);
		}
		
		public function ShowInvite4UnlockPopup(lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function):void
		{
			_notificationsPanel.Push(new Invite4UnlockPopup(lobbyMachine, onClose), true);
		}
		public function ShowInviting4UnlockPopup(lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function):void
		{
			_notificationsPanel.Push(new Inviting4UnlockPopup(lobbyMachine, onClose), true);
		}
		public function ShowInvited4UnlockPopup(lobbyMachine:SlotsBaseLobbyMachineData, count:int):void
		{
			_notificationsPanel.Push(new Invited4UnlockPopup(lobbyMachine, count), true);
		}
		
		public function ShowJackpotInfoPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new JackpotInfoPopup(onClose));
		}
		public function ShowLevelInfoPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new LevelInfoPopup(onClose));
		}
		public function ShowLevelUpPopup(level:LevelData, onClose:Function):void
		{
			_notificationsPanel.Push(new LevelUpPopup(level, onClose));
		}
		public function ShowLoggedOnPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new LoggedOnPopup(onClose), true);
		}
		public function ShowLowChipsPopup(onClose:Function):void
		{
			if (Main.Instance.ActiveMachine)
			{
				_notificationsPanel.Push(new LowChipsPopup(onClose));
			}
		}
		public function ShowNewMachinePopup(lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function):void
		{
			if (lobbyMachine.ID != Main.Instance.Session.Machines.MachinesSession[1].LobbyMachine.ID)
			{
				_notificationsPanel.Push(new NewMachinePopup(lobbyMachine, onClose));
			}
		}
		public function ShowNoChipsPopup(onClose:Function):void
		{
			if (Main.Instance.ActiveMachine)
			{
				_notificationsPanel.Push(new NoChipsBuyChipsPopup(onClose));
			}
		}
		public function ShowNoConnectionPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new NoConnectionPopup(onClose));
		}
		public function ShowMachineInfoPopup(machineInfoPage:int, lobbyMachine:SlotsBaseLobbyMachineData, onClose:Function):void
		{
			_notificationsPanel.Push(new SlotsMachineInfoPopup(machineInfoPage, lobbyMachine, onClose));
		}
		public function ShowPromptOnClosePopup(onClose:Function):void
		{
			_notificationsPanel.Push(new PromptOnClosePopup(onClose));
		}
		public function ShowMenuSettingsPopup(onClose:Function):void
		{
			if (!ShowingNotifications)
			{
				_notificationsPanel.Push(new SettingsPopup(onClose));
			}
		}
		public function ShowSettingsPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new SettingsPopup(onClose));
		}
		public function ShowWelcomePopup(onClose:Function):void
		{
			if (!Main.Instance.Session.Rare.IsWelcomeCollected)
			{
				_notificationsPanel.Push(new WelcomePopup(onClose));
			}
		}
	}
}