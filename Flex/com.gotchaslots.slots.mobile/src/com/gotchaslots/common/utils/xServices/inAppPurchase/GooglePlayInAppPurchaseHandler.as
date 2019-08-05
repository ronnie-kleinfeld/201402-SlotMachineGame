package com.gotchaslots.common.utils.xServices.inAppPurchase
{
	import com.gotchaslots.common.data.application.prices.ProductID;
	import com.gotchaslots.common.utils.xServices.inAppPurchase.base.BaseInAppPurchaseHandler;
	import com.gotchaslots.common.utils.xServices.inAppPurchase.base.InAppPurchaseHandlerEvent;
	import com.gotchaslots.slots.utils.consts.SlotsConsts;
	import com.milkmangames.nativeextensions.android.AndroidIAB;
	import com.milkmangames.nativeextensions.android.events.AndroidBillingErrorEvent;
	import com.milkmangames.nativeextensions.android.events.AndroidBillingEvent;
	
	import flash.events.Event;
	
	public class GooglePlayInAppPurchaseHandler extends BaseInAppPurchaseHandler
	{
		// class
		public function GooglePlayInAppPurchaseHandler()
		{
			super();
		}
		public override function Init():Boolean
		{
			if (!_initialized)
			{
				if (AndroidIAB.isSupported())
				{
					try
					{
						AndroidIAB.create();
						AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY, OnServiceReady);
						AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED, OnPurchaseSuccessed);
						AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, OnConsumeSuccessed);
						AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.CONSUME_FAILED, OnConsumeFailed);
						AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, OnPurchaseFailed);
						AndroidIAB.androidIAB.startBillingService(SlotsConsts.GOOGLE_PLAY_LICENSE_KEY);
					}
					catch (error:Error)
					{
					}
					
					_initialized = true;
				}
				else
				{
					Failed();
				}
			}
			
			return _initialized;
		}
		protected function OnServiceReady(event:Event):void
		{
			GetInventory();
		}
		
		// inventory
		private function GetInventory():void
		{
			AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED, OnInventoryLoaded);
			AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, OnLoadInventoryFailed);
			AndroidIAB.androidIAB.loadPlayerInventory(true);
		}
		protected function OnInventoryLoaded(event:AndroidBillingEvent):void
		{
			AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.INVENTORY_LOADED, OnInventoryLoaded);
			AndroidIAB.androidIAB.removeEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, OnLoadInventoryFailed);
			
			AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, OnConsumeSuccessed);
			for (var i:int = 0; i < event.purchases.length; i++)
			{
				AndroidIAB.androidIAB.consumeItem(event.purchases[0].itemId);
			}
			AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, OnConsumeSuccessed);
		}
		protected function OnLoadInventoryFailed(event:Event):void
		{
			AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.INVENTORY_LOADED, OnInventoryLoaded);
			AndroidIAB.androidIAB.removeEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, OnLoadInventoryFailed);
		}
		
		// purchase
		public override function Purchase(productID:String):void
		{
			if (Init())
			{
				AndroidIAB.androidIAB.purchaseItem(productID);
			}
		}
		protected function OnPurchaseSuccessed(event:AndroidBillingEvent):void
		{
			if (event.purchases)
			{
				AndroidIAB.androidIAB.consumeItem(event.purchases[0].itemId);
			}
			else
			{
				dispatchEvent(new InAppPurchaseHandlerEvent(InAppPurchaseHandlerEvent.PurchaseCanceled));
			}
		}
		protected function OnConsumeSuccessed(event:AndroidBillingEvent):void
		{
			dispatchEvent(new InAppPurchaseHandlerEvent(InAppPurchaseHandlerEvent.PurchaseSuccessed));
		}
		
		protected function OnPurchaseFailed(event:Event):void
		{
			AndroidIAB.androidIAB.consumeItem(ProductID.USD99);
		}
		protected function OnConsumeFailed(event:AndroidBillingErrorEvent):void
		{
			Failed();
		}
	}
}