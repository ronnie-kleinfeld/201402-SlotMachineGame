package com.gotchaslots.common.utils.xServices.ads.base
{
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;

	public class BaseAdsHandler extends EventDispatcherEx
	{
		// members
		protected var _initialized:Boolean;
		
		// class
		public function BaseAdsHandler()
		{
			super();
			
			Init();
		}
		protected function Init():Boolean
		{
			throw new MustOverrideError();
		}
		
		// banner
		public function ShowBanner():void
		{
			throw new MustOverrideError();
		}
		public function RemoveBanner():void
		{
			throw new MustOverrideError();
		}
		
		// banner
		public function LoadInterstitial():void
		{
			throw new MustOverrideError();
		}
		public function ShowInterstitial():void
		{
			throw new MustOverrideError();
		}
		public function RemoveInterstitial():void
		{
			throw new MustOverrideError();
		}
	}
}