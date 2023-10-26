package com.gotchaslots.common.utils.xServices.googleAnalytics
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.utils.consts.SlotsConsts;
	import com.milkmangames.nativeextensions.GAnalytics;
	
	// http://www.google.com/analytics/
	// https://www.google.com/analytics/web/?hl=en#report/app-overview/a43695973w73793511p76190361/
	// https://www.google.com/analytics/web/?hl=en#realtime/rt-app-overview/a43695973w73793511p76190361/
	public class GoogleAnalyticsHandler
	{
		// consts
		private const MANUAL_DISPATCH:Boolean = false;
		
		// memebrs
		private var _initialized:Boolean;
		
		// properties
		private function get IsSupported():Boolean
		{
			return _initialized && GAnalytics.isSupported();
		}
		
		// class
		public function GoogleAnalyticsHandler()
		{
			if (GAnalytics.isSupported())
			{
				GAnalytics.create(SlotsConsts.GOOGLE_ANALYTICS_TRACKING_ID);
				
				_initialized = true;
			}
		}
		
		// methods
		public function ForseDispatch():void
		{
			if (IsSupported)
			{
				GAnalytics.analytics.forceDispatchHits();
			}
		}
		
		// view
		public function TrackMainView():void
		{
			TrackView("Main");
		}
		public function TrackLobbyView():void
		{
			TrackView("Lobby");
		}
		public function TrackMachineView(MachineID:int):void
		{
			TrackView("Machine:" + MachineID);
		}
		public function TrackBonusGameView(MachineID:int):void
		{
			TrackView("BonusGame for Machine:" + MachineID);
		}
		public function TrackPurchasePopupView():void
		{
			TrackView("PurchasePopup");
		}
		private function TrackView(view:String):void
		{
			if (IsSupported)
			{
				GAnalytics.analytics.defaultTracker.trackScreenView(view);
			}
		}
		
		// event
		public function TrackLogin():void
		{
			TrackEvent("Facebook", "Login", Main.Instance.XServices.Social.FacebookUid);
		}
		public function TrackLogout():void
		{
			TrackEvent("Facebook", "Logout", Main.Instance.XServices.Social.FacebookUid);
		}
		public function TrackInvite(count:int):void
		{
			TrackEvent("Facebook", "Invite", Main.Instance.XServices.Social.FacebookUid, count);
		}
		public function TrackShare(share:String):void
		{
			TrackEvent("Facebook", share, Main.Instance.XServices.Social.FacebookUid);
		}
		
		public function TrackCollectTimerBonus(diff:Number):void
		{
			TrackEvent("TimerBonus", "Collect(Seconds)", Main.Instance.Device.DeviceID, diff);
		}
		
		public function TrackMachineClose(machineName:String, timeOnMachine:Number, spinsOnMachine:int, freeSpinsOnMachine:int, chipsSpentOnMachine:Number):void
		{
			TrackEvent("Machine", "Time(ms)", machineName, timeOnMachine);
			TrackEvent("Machine", "Spins", machineName, spinsOnMachine);
			TrackEvent("Machine", "Free spins", machineName, freeSpinsOnMachine);
			TrackEvent("Machine", "Chips spent", machineName, chipsSpentOnMachine);
		}
		
		public function TrackPurchaseEventShowBuyChipsPopup():void
		{
			TrackEvent("Purchase3", "1.0.BuyChipsPopup_Show", "BuyChipsPopup");
		}
		public function TrackPurchaseEventClickBuyChipsPopup(ms:Number):void
		{
			TrackEvent("Purchase3", "1.1.BuyChipsPopup_ClickAnOption", "BuyChipsPopup", ms);
		}
		public function TrackPurchaseEventCloseBuyChipsPopup(ms:Number):void
		{
			TrackEvent("Purchase3", "1.2.BuyChipsPopup_Close", "BuyChipsPopup", ms);
		}
		public function TrackPurchaseEventShowBuyingChipsPopup():void
		{
			TrackEvent("Purchase3", "2.0.BuyingChipsPopup_Show", "BuyingChipsPopup");
		}
		public function TrackPurchaseEventSuccessBuyingChipsPopup(ms:Number):void
		{
			TrackEvent("Purchase3", "2.1.BuyingChipsPopup_Success", "BuyingChipsPopup", ms);
		}
		public function TrackPurchaseEventFailedBuyingChipsPopup(ms:Number):void
		{
			TrackEvent("Purchase3", "2.2.BuyingChipsPopup_Failed", "BuyingChipsPopup", ms);
		}
		public function TrackPurchaseEventCancelBuyingChipsPopup(ms:Number):void
		{
			TrackEvent("Purchase3", "2.3.BuyingChipsPopup_Cancel", "BuyingChipsPopup", ms);
		}
		public function TrackPurchaseEventShowChipsBoughtPopup():void
		{
			TrackEvent("Purchase3", "3.0.ChipsBoughtPopup_Show", "ChipsBoughtPopup");
		}
		public function TrackPurchaseEventCollectChipsBoughtPopup(ms:Number):void
		{
			TrackEvent("Purchase3", "3.1.ChipsBoughtPopup_Collect", "ChipsBoughtPopup", ms);
		}
		public function TrackPurchaseEventShowNoChargePopup():void
		{
			TrackEvent("Purchase3", "9.0.NoChargePopup_Show", "NoChargePopup");
		}
		public function TrackPurchaseEventOKNoChargePopup(ms:Number):void
		{
			TrackEvent("Purchase3", "9.1.NoChargePopup_OK", "NoChargePopup", ms);
		}
		
		public function TrackPurchaseGooglePlayPurchaseEvent(productID:String, chips:int):void
		{
			TrackEvent("GooglePlay", "1.Purchase", productID, chips);
		}
		public function TrackPurchaseGooglePlaySuccessEvent(productID:String, chips:int):void
		{
			TrackEvent("GooglePlay", "2.Succcess", productID, chips);
		}
		public function TrackPurchaseGooglePlayFailedEvent(productID:String, chips:int):void
		{
			TrackEvent("GooglePlay", "3.Failed", productID, chips);
		}
		
		public function TrackPurchaseAppStorePurchaseEvent(productID:String, chips:int):void
		{
			TrackEvent("AppStore", "1.Purchase", productID, chips);
		}
		public function TrackPurchaseAppStoreSuccessEvent(productID:String, chips:int):void
		{
			TrackEvent("AppStore", "2.Succcess", productID, chips);
		}
		public function TrackPurchaseAppStoreFailedEvent(productID:String, chips:int):void
		{
			TrackEvent("AppStore", "3.Failed", productID, chips);
		}
		
		public function TrackRateSelected():void
		{
			TrackEvent("Rate", "Rate Selected");
		}
		public function TrackLaterSelected():void
		{
			TrackEvent("Rate", "Later Selected");
		}
		public function TrackNeverSelected():void
		{
			TrackEvent("Rate", "Never Selected");
		}
		public function TrackPromptDisplayed():void
		{
			TrackEvent("Rate", "Prompt Displayed");
		}
		
		private function TrackEvent(category:String, action:String, label:String = null, value:Number = Number.NaN):void
		{
			if (IsSupported)
			{	
				GAnalytics.analytics.defaultTracker.trackEvent(category, action, label, value);
			}
		}
		
		// exception
		public function TrackFatalError(errorMessage:String):void
		{
			if (IsSupported)
			{
				GAnalytics.analytics.defaultTracker.trackException("Device:" + Main.Instance.Device.DeviceID + ":" + errorMessage, true);
			}
		}
		
		// ecommerce transaction
		// tracker.buildTransaction(UIDUtil.createUID(), 10.5)
		// 	.createProduct("cr-300", "300 credits pack", 7, 1).inCategory("credits").add()
		// 	.createProduct("it-156", "extra life item", 1.5, 2).add()
		// 	.track();
		public function TrackPurchaseTransaction(name:String, cost:Number, chips:Number, productID:String, description:String):void
		{
			TrackTransaction(Main.Instance.Device.DeviceID, cost, productID, name, cost, chips, description); 
		}
		private function TrackTransaction(id:String, cost:Number, sku:String, name:String, price:Number, quantity:uint, description:String):void
		{
			if (IsSupported)
			{
				GAnalytics.analytics.defaultTracker.trackTransaction(id, "", price - cost);
				GAnalytics.analytics.defaultTracker.trackItem(id, name, sku, price, null, quantity)
			}
		}
	}
}