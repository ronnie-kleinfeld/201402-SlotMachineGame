package com.gotchaslots.common.utils.xServices.inAppPurchase.base
{
	import flash.events.Event;
	
	public class InAppPurchaseHandlerEvent extends Event
	{
		public static const Failed:String = "a2f259bd248e44e09559fe83d148756e";
		public static const PurchaseSuccessed:String = "8fefa8d12aca40348875f188b6e45e10";
		public static const PurchaseCanceled:String = "ebc3a3cdd5b242bcbf9daf3e611cb047";
		
		// class
		public function InAppPurchaseHandlerEvent(type:String)
		{
			super(type);
		}
	}
}