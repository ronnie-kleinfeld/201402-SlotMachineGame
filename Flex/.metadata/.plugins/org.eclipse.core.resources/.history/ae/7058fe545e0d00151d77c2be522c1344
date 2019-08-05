package com.gotchaslots.common.ui.notifications.popup.settings.buttons
{
	import com.gotchaslots.common.assets.notifications.popup.settings.SettingsEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LogoutButton extends BaseClickableButton
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupButtonSecondary;
		}
		
		// class
		public function LogoutButton()
		{
			super(36, 36, null, "", new SettingsEmbed.FacebookNormal(), new SettingsEmbed.FacebookSelected(), Number.NaN);
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			super.OnClick(event);
			Main.Instance.XServices.Social.Logout();
		}
	}
}