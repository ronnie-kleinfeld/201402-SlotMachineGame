package com.gotchaslots.common.ui.notifications.popup.settings
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.ui.notifications.popup.settings.groups.AllowShareGroup;
	import com.gotchaslots.common.ui.notifications.popup.settings.groups.InviteFriendsGroup;
	import com.gotchaslots.common.ui.notifications.popup.settings.groups.LoginLogoutGroup;
	import com.gotchaslots.common.ui.notifications.popup.settings.groups.VolumeSettingsGroup;
	
	import flash.events.Event;
	
	public class SettingsPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.SmallPopup;
		}
		protected override function get X():int
		{
			return 800 - Width - 26;
		}
		protected override function get Y():int
		{
			return 42;
		}
		protected override function get Width():int
		{
			return 306;
		}
		protected override function get Height():int
		{
			return Main.Instance.XServices.Social.IsFacebookLogon ? 261 : 163;
		}
		
		protected override function get Title():String
		{
			return "Settings";
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function SettingsPopup(onClose:Function)
		{
			super(onClose);
		}
		protected override function AddBody():void
		{
			var volumeGroup:VolumeSettingsGroup = new VolumeSettingsGroup(Width * 0.9, 40);
			volumeGroup.x = Width * 0.05;
			AddComponent(volumeGroup);
			
			AddComponent(new Spacer(6));
			
			if (Main.Instance.XServices.Social.IsFacebookLogon)
			{
				var allowShareGroup:AllowShareGroup = new AllowShareGroup(Width * 0.9, 40);
				allowShareGroup.x = Width * 0.05;
				AddComponent(allowShareGroup);
				
				AddComponent(new Spacer(6));
				
				var inviteFriendsGroup:InviteFriendsGroup = new InviteFriendsGroup(Width * 0.9, 40);
				inviteFriendsGroup.x = Width * 0.05;
				AddComponent(inviteFriendsGroup);
				
				AddComponent(new Spacer(6));
			}
			
			var loginLogoutGroup:LoginLogoutGroup = new LoginLogoutGroup(Width * 0.9, 40, OnCloseClick);
			loginLogoutGroup.x = Width * 0.05;
			AddComponent(loginLogoutGroup);
		}
		
		private function OnCloseClick(event:Event):void
		{
			DoRemove();
		}
	}
}