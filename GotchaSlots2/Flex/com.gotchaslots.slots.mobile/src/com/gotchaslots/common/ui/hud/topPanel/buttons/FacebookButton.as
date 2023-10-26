package com.gotchaslots.common.ui.hud.topPanel.buttons
{
	import com.gotchaslots.common.assets.hud.topPanel.TopPanelEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	import com.gotchaslots.common.utils.xServices.social.SocialEvent;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FacebookButton extends BaseClickableButton
	{
		// class
		public function FacebookButton()
		{
			super(44, 44, null, null, new TopPanelEmbed.FacebookNormal(), new TopPanelEmbed.FacebookSelected());
			
			ShowHide();
			
			Main.Instance.XServices.Social.addEventListener(SocialEvent.FacebookLogonChanged, OnFacebookLogonChanged);
		}
		public override function Dispose():void
		{
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.FacebookLogonChanged, OnFacebookLogonChanged);
			
			super.Dispose();
		}
		
		// methods
		private function ShowHide():void
		{
			TweenLite.to(this, 0.5, {alpha:Main.Instance.XServices.Social.IsFacebookLogon ? 0 : 1});
		}
		
		// events
		protected function OnFacebookLogonChanged(event:Event):void
		{
			ShowHide();
		}
		
		protected override function OnClick(event:MouseEvent):void
		{
			Main.Instance.Sounds.Play(SlotsSoundsManager.TopPanel_Click);
			super.OnClick(event);
			SlotsNotificationsHandler.Instance.ShowConnectingPopup(null);
		}
	}
}