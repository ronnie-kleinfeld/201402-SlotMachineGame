package com.gotchaslots.common.ui.notifications.popup.settings.buttons
{
	import com.gotchaslots.common.assets.notifications.popup.settings.SettingsEmbed;
	import com.gotchaslots.common.ui.notifications.popup.base.BaseVolumeButton;
	
	public class VolumeSettingsButton extends BaseVolumeButton
	{
		// class
		public function VolumeSettingsButton()
		{
			super(36, 36, new SettingsEmbed.SoundOnOffNormal(), new SettingsEmbed.SoundOnOffSelected());
		}
	}
}