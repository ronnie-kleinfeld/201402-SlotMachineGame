package com.gotchaslots.common.utils.xServices.rate
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.gotchaslots.slots.utils.consts.SlotsConsts;
	import com.milkmangames.nativeextensions.RateBox;
	import com.milkmangames.nativeextensions.events.RateBoxEvent;
	
	import flash.events.Event;
	
	public class RateHandler extends EventDispatcherEx
	{
		// class
		public function RateHandler()
		{
			if (RateBox.isSupported())
			{
				RateBox.create(SlotsConsts.APPLE_APP_ID,
					SlotsConsts.APP_NAME,
					"If you like this app, please rate it 5 stars!",
					"Rate Now",
					"Not now",
					"Don't ask again",
					3, 5, 0, 7);
				
				RateBox.rateBox.addEventListener(RateBoxEvent.RATE_SELECTED, OnRateSelected);
				RateBox.rateBox.addEventListener(RateBoxEvent.LATER_SELECTED, OnLaterSelected);
				RateBox.rateBox.addEventListener(RateBoxEvent.NEVER_SELECTED, OnNeverSelected);
				RateBox.rateBox.addEventListener(RateBoxEvent.PROMPT_DISPLAYED, OnPropmtDisplayed);
			}
		}
		
		// methods
		public function IncrementEventCount():void
		{
			if (RateBox.isSupported() && RateBox.rateBox)
			{
				RateBox.rateBox.incrementEventCount();
			}
		}
		
		// events
		protected function OnRateSelected(event:Event):void
		{
			Main.Instance.XServices.GoogleAnalytics.TrackRateSelected();
		}
		protected function OnLaterSelected(event:Event):void
		{
			Main.Instance.XServices.GoogleAnalytics.TrackLaterSelected();
		}
		protected function OnNeverSelected(event:Event):void
		{
			Main.Instance.XServices.GoogleAnalytics.TrackNeverSelected();
		}
		protected function OnPropmtDisplayed(event:Event):void
		{
			Main.Instance.XServices.GoogleAnalytics.TrackPromptDisplayed();
		}
	}
}