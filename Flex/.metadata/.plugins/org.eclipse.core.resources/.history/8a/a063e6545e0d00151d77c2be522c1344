package com.gotchaslots.common.ui.hud.tickerPanel
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.MainEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	public class BubblingTickerTextField extends BaseTextField
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.HudTickerBubbling;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 60;
		}
		
		// class
		public function BubblingTickerTextField()
		{
			super(640, 36, "Bubbling");
			
			Main.Instance.addEventListener(MainEvent.RemoveActiveMachineView, OnRemoveActiveMachineView);
		}
		
		// events
		protected function OnRemoveActiveMachineView(event:Event):void
		{
			TweenLite.to(this, 0.5, {alpha:0, onComplete:OnComplete});
		}
		private function OnComplete():void
		{
			Dispose();
		}
	}
}