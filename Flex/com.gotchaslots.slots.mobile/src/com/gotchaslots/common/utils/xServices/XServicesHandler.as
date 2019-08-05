package com.gotchaslots.common.utils.xServices
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.consts.DeviceTypeEnum;
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.common.utils.xServices.Network.NetworkHandler;
	import com.gotchaslots.common.utils.xServices.ads.AdMobHandler;
	import com.gotchaslots.common.utils.xServices.ads.IAdHandler;
	import com.gotchaslots.common.utils.xServices.ads.base.BaseAdsHandler;
	import com.gotchaslots.common.utils.xServices.deviceID.DeviceIDHandler;
	import com.gotchaslots.common.utils.xServices.googleAnalytics.GoogleAnalyticsHandler;
	import com.gotchaslots.common.utils.xServices.inAppPurchase.AppStoreInAppPurchaseHandler;
	import com.gotchaslots.common.utils.xServices.inAppPurchase.GooglePlayInAppPurchaseHandler;
	import com.gotchaslots.common.utils.xServices.inAppPurchase.base.BaseInAppPurchaseHandler;
	import com.gotchaslots.common.utils.xServices.internetTime.InternetTimeHandler;
	import com.gotchaslots.common.utils.xServices.localNotifications.LocalNotificationsHandler;
	import com.gotchaslots.common.utils.xServices.nativeDialogs.NativeDialogsHandler;
	import com.gotchaslots.common.utils.xServices.parse.ParseHandler;
	import com.gotchaslots.common.utils.xServices.rate.RateHandler;
	import com.gotchaslots.common.utils.xServices.social.SocialHandler;
	import com.gotchaslots.common.utils.xServices.vibtate.VibrateHandler;
	
	public class XServicesHandler extends EventDispatcherEx
	{
		// members
		private var _ads:BaseAdsHandler;
		private var _deviceID:DeviceIDHandler;
		private var _googleAnalytics:GoogleAnalyticsHandler;
		private var _inAppPurchase:BaseInAppPurchaseHandler;
		private var _internetTime:InternetTimeHandler;
		private var _localNotifications:LocalNotificationsHandler;
		private var _nativeDialogs:NativeDialogsHandler;
		private var _network:NetworkHandler;
		private var _parse:ParseHandler;
		private var _rate:RateHandler;
		private var _social:SocialHandler;
		private var _vibrate:VibrateHandler;
		
		// properties
		public function get Ads():BaseAdsHandler
		{
			return _ads;
		}
		public function get DeviceID():DeviceIDHandler
		{
			return _deviceID;
		}
		public function get GoogleAnalytics():GoogleAnalyticsHandler
		{
			return _googleAnalytics;
		}
		public function get InAppPurchase():BaseInAppPurchaseHandler
		{
			return _inAppPurchase;
		}
		public function get InternetTime():InternetTimeHandler
		{
			return _internetTime;
		}
		public function get LocalNotifications():LocalNotificationsHandler
		{
			return _localNotifications;
		}
		public function get NativeDialogs():NativeDialogsHandler
		{
			return _nativeDialogs;
		}
		public function get Network():NetworkHandler
		{
			return _network;
		}
		public function get Parse():ParseHandler
		{
			return _parse;
		}
		public function get Rate():RateHandler
		{
			return _rate;
		}
		public function get Social():SocialHandler
		{
			return _social;
		}
		public function get Vibrate():VibrateHandler
		{
			return _vibrate;
		}
		
		public function get AppUrl():String
		{
			throw new MustOverrideError();
		}
		
		// class
		public function XServicesHandler()
		{
			super();
			
			_deviceID = new DeviceIDHandler();
			_internetTime = new InternetTimeHandler();
			_localNotifications = new LocalNotificationsHandler();
			_nativeDialogs = new NativeDialogsHandler();
			_network = new NetworkHandler();
			_parse = new ParseHandler();
			_rate = new RateHandler();
			_social = new SocialHandler();
			_vibrate = new VibrateHandler();
		}
		public function Init():void
		{
			InitAdsHandler();
			InitGoogleAnalytics();
			InitInAppPurchaseHandler();
		}
		private function InitAdsHandler():void
		{
			switch (Main.Instance.Device.DeviceType)
			{
				case DeviceTypeEnum.ANDORID:
					_ads = new AdMobHandler();
					break;
				case DeviceTypeEnum.IPHONE:
					_ads = new IAdHandler();
					break;
				default:
					_ads = new AdMobHandler();
					break;
			}
		}
		private function InitGoogleAnalytics():void
		{
			_googleAnalytics = new GoogleAnalyticsHandler();
		}
		private function InitInAppPurchaseHandler():void
		{
			switch (Main.Instance.Device.DeviceType)
			{
				case DeviceTypeEnum.ANDORID:
					_inAppPurchase = new GooglePlayInAppPurchaseHandler();			
					break;
				case DeviceTypeEnum.IPHONE:
					_inAppPurchase = new AppStoreInAppPurchaseHandler();			
					break;
				default:
					_inAppPurchase = new GooglePlayInAppPurchaseHandler();
					break;
			}
		}
	}
}