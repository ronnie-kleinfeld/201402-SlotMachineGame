package com.gotchaslots.common.utils.xServices.Network
{
	import com.gotchaslots.common.utils.xServices.BaseCoreMobileHandler;
	import com.milkmangames.nativeextensions.CMNetworkType;
	import com.milkmangames.nativeextensions.CoreMobile;
	import com.milkmangames.nativeextensions.events.CMNetworkEvent;
	
	public class NetworkHandler extends BaseCoreMobileHandler
	{
		// properties
		public function get NetworkType():String
		{
			if (Init())
			{
				var networkType:int = CoreMobile.mobile.getNetworkType();
				switch(networkType)
				{
					case CMNetworkType.NONE:
						return NetworkTypeEnum.NONE;
					case CMNetworkType.MOBILE:
						return NetworkTypeEnum.MOBILE;
					case CMNetworkType.WIFI:
						return NetworkTypeEnum.WIFI;
					default:
						return NetworkTypeEnum.NONE;
				}
			}
			else
			{
				return NetworkTypeEnum.NONE;
			}
		}		

		// class
		public function NetworkHandler()
		{
			super();
		}
				
		// monitor network
		public function MonitorNetworkChanges():void
		{
			if (Init())
			{
				CoreMobile.mobile.addEventListener(CMNetworkEvent.NETWORK_REACHABILITY_CHANGED, onNetworkRechabilityChanged);
			}
		}
		private function onNetworkRechabilityChanged(event:CMNetworkEvent):void
		{
			dispatchEvent(new NetworkEvent(NetworkEvent.NetworkChanged));
		}
	}
}