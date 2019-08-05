package com.gotchaslots.common.ui.hud.topPanel.buttons
{
	import com.gotchaslots.common.assets.hud.topPanel.TopPanelEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.notifications.popup.base.BaseVolumeButton;
	
	public class VolumeTopBarButton extends BaseVolumeButton
	{
		// class
		public function VolumeTopBarButton()
		{
			super(44, 44, new TopPanelEmbed.SoundOnOffNormal(), new TopPanelEmbed.SoundOnOffSelected());
			
			SetState();
			
			Main.Instance.Session.Wallet.addEventListener(SessionDataEvent.VolumeChanged, OnVolumeChanged);
		}
		public override function Dispose():void
		{
			Main.Instance.Session.Wallet.removeEventListener(SessionDataEvent.VolumeChanged, OnVolumeChanged);

			super.Dispose();
		}
	}
}