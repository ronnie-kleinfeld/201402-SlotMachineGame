package com.gotchaslots.common.utils.xServices.inAppPurchase.base
{
	import com.gotchaslots.common.utils.error.MustOverrideError;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	public class BaseInAppPurchaseHandler extends EventDispatcherEx
	{
		// members
		protected var _initialized:Boolean;
		
		// class
		public function BaseInAppPurchaseHandler()
		{
			super();
			
			Init();
		}
		public function Init():Boolean
		{
			throw new MustOverrideError();
		}
		
		// methods
		public function Purchase(productID:String):void
		{
			throw new MustOverrideError();
		}
		protected function Failed():void
		{
			_initialized = false;
			dispatchEvent(new InAppPurchaseHandlerEvent(InAppPurchaseHandlerEvent.Failed));
		}
	}
}