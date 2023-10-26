package com.gotchaslots.common.ui.notifications.popup.settings.buttons
{
	import com.gotchaslots.common.assets.notifications.popup.PopupEmbed;
	import com.gotchaslots.common.assets.notifications.popup.settings.SettingsEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	import flash.text.TextField;
	
	public class InviteFriendsButton extends BaseClickableButton
	{
		// properties
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupButtonMain;
		}
		
		// class
		public function InviteFriendsButton()
		{
			super(36, 36, null, "", new SettingsEmbed.FacebookInviteNormal(), new SettingsEmbed.FacebookInviteSelected(), Number.NaN);
		}
	}
}