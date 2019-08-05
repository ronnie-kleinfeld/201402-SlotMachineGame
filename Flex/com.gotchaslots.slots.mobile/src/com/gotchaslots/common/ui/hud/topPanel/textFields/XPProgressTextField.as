package com.gotchaslots.common.ui.hud.topPanel.textFields
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	public class XPProgressTextField extends BaseTextField
	{
		// members
		private var _currentXP:Number;
		private var _diff:Number;
		
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.HudTopPanelXP;
		}
		
		// class
		public function XPProgressTextField()
		{
			super(306, 28, FormatterHelper.NumberToMoney(Math.floor(Main.Instance.Session.Wallet.GetXP), 0) + "/" + FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.NextMinXP - 1, 0));
			
			Main.Instance.Session.Wallet.addEventListener(SessionDataEvent.XPChanged, OnXPChanged);
		}
		public override function Dispose():void
		{
			Main.Instance.Session.Wallet.removeEventListener(SessionDataEvent.XPChanged, OnXPChanged);
			
			super.Dispose();
		}
		
		// events
		protected function OnXPChanged(event:SessionDataEvent):void
		{
			_currentXP = event.Value;
			_diff = (Main.Instance.Session.Wallet.GetXP - event.Value) / (5000 / Main.Instance.Device.DeviceStage.frameRate);
			addEventListener(Event.ENTER_FRAME, OnEnterFrame);
		}
		protected function OnEnterFrame(event:Event):void
		{
			_currentXP += _diff;
			if (_currentXP >= Main.Instance.Session.Wallet.GetXP)
			{
				removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
				_currentXP = Main.Instance.Session.Wallet.GetXP;
			}
			Text = FormatterHelper.NumberToMoney(_currentXP, 0) + "/" + FormatterHelper.NumberToMoney(Main.Instance.Session.Wallet.GetLevel.NextMinXP - 1, 0);
		}
	}
}