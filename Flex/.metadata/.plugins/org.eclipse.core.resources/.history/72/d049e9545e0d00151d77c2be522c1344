package com.gotchaslots.common.ui.lobby
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.application.prices.PriceOptionsData;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.ui.lobby.machineList.MachinesList;
	import com.gotchaslots.common.ui.lobby.promotionPanel.PromotionPanel;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	
	import flash.events.Event;
	
	public class LobbyPanel extends SpriteEx
	{
		// members
		private var _machinesList:MachinesList;
		private var _promotionPanel:PromotionPanel;
		
		// class
		public function LobbyPanel()
		{
			super();
			
			Main.Instance.XServices.GoogleAnalytics.TrackLobbyView();
			
			InitMachinesList();
			InitPromotionPanel();
			
			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
		}
		public function InitMachinesList():void
		{
			_machinesList = new MachinesList();
			_machinesList.y = 48;
			addChild(_machinesList);
		}
		public function InitPromotionPanel():void
		{
			_promotionPanel = new PromotionPanel();
			_promotionPanel.y = 48 + 306;
			addChild(_promotionPanel);
		}
		
		// methods
		public function Start():void
		{
			_machinesList.Start();
			_promotionPanel.Start();
		}
		public function Stop():void
		{
			_machinesList.Stop();
			_promotionPanel.Stop();
		}
		
		// event
		protected function OnAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			
			if (!Main.Instance.Session.Rare.IsWelcomeCollected)
			{
				SlotsNotificationsHandler.Instance.ShowWelcomePopup(OnLobbyLoaded);
			}
			else if (!Main.Instance.Session.Rare.IsInviteAsked)
			{
				SlotsNotificationsHandler.Instance.ShowInvite4ChipsPopup(OnLobbyLoaded);
			}
			else if (Main.Instance.XServices.InternetTime.IsInternetTime)
			{
				SlotsNotificationsHandler.Instance.ShowDailyBonusPopup(OnLobbyLoaded);
			}
			else
			{
				var priceOptions:PriceOptionsData = Main.Instance.Application.Prices.GetPriceOptions(true);
				if (priceOptions)
				{
					SlotsNotificationsHandler.Instance.ShowBuyChipsPopup(true, OnLobbyLoaded);
				}
			}
			
			if (!Main.Instance.XServices.Social.IsFacebookLogon)
			{
				SlotsNotificationsHandler.Instance.ShowConnectPopup(OnLobbyLoaded);
			}
		}
		private function OnLobbyLoaded():void
		{
		}
	}
}