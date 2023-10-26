package com.gotchaslots.common.ui.notifications.popup.settings.buttons
{
	import com.gotchaslots.common.assets.notifications.popup.settings.SettingsEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseSwitchableButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AllowShareButton extends BaseSwitchableButton
	{
		// class
		public function AllowShareButton()
		{
			super(36, 36, null, null, null, new SettingsEmbed.AllowShareNormal(), new SettingsEmbed.AllowShareSelected(), Number.NaN);
			
			SetState();
			
			Main.Instance.Session.Rare.addEventListener(SessionDataEvent.AllowShareChanged, OnAllowShareChanged);
		}
		public override function Dispose():void
		{
			Main.Instance.Session.Rare.removeEventListener(SessionDataEvent.AllowShareChanged, OnAllowShareChanged);
			
			super.Dispose();
		}
		
		// methods
		protected function SetState():void
		{
			switch (Main.Instance.Session.Rare.AllowShare)
			{
				case false:
					SetSelected();
					break;
				case true:
					SetNormal();
					break;
			}
		}
		
		// events
		protected function OnAllowShareChanged(event:Event):void
		{
			SetState();
		}
		
		protected override function OnNormal(event:MouseEvent):void
		{
			Main.Instance.Session.Rare.AllowShare = true;
		}
		protected override function OnSelected(event:MouseEvent):void
		{
			Main.Instance.Session.Rare.AllowShare = false;
		}
	}
}