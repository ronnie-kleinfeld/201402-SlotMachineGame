package com.gotchaslots.common.ui.hud.jackpot
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class JackpotRibbon extends BaseTextField
	{
		// properties
		protected override function get HasFrame():Boolean
		{
			return true;
		}
		protected override function get FrameColorHigh():Number
		{
			return 0x8330ba;
		}
		protected override function get FrameColorLow():Number
		{
			return 0x8330ba;
		}
		protected override function get FrameFilters():Array
		{
			return [new BevelFilter(4, 45, 0x8330ba, 1, 0)];
		}
		protected override function get FrameCorner():Number
		{
			return 30;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.HudJackpot;
		}
		protected override function get TextFieldOffsetY():int
		{
			return 8;
		}
		protected override function get MaxTextFieldSize():int
		{
			return 60;
		}
		private function get GetText():String
		{
			return "Jackpot " + FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetJackpot);
		}
		
		// class
		public function JackpotRibbon()
		{
			super(350, 45, GetText, null, 0xfdeaf4);
			
			filters = [new GlowFilter(0xEC9EFE, 1, 5, 5)];
			
			Main.Instance.Session.Wallet.addEventListener(SessionDataEvent.JackpotChanged, OnJackpotChanged);
			addEventListener(MouseEvent.CLICK, OnClick);
		}
		public override function Dispose():void
		{
			removeEventListener(MouseEvent.CLICK, OnClick);
			Main.Instance.Session.Wallet.removeEventListener(SessionDataEvent.JackpotChanged, OnJackpotChanged);
			super.Dispose();
		}
		
		// events
		protected function OnJackpotChanged(event:Event):void
		{
			Text = GetText;
		}
		protected function OnClick(event:MouseEvent):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.TopPanel_Click);
			SlotsNotificationsHandler.Instance.ShowJackpotInfoPopup(null);
		}
	}
}