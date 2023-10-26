package com.gotchaslots.common.ui.notifications.popup.invite4Chips
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.AndroidLoader;
	import com.gotchaslots.common.ui.common.components.Spacer;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.base.PopupSizeTypeEnum;
	import com.gotchaslots.common.utils.xServices.social.SocialEvent;
	
	import flash.events.Event;
	
	public class Inviting4ChipsPopup extends BasePopup
	{
		// properties
		protected override function get SizeType():String
		{
			return PopupSizeTypeEnum.SmallPopup;
		}
		
		protected override function get Title():String
		{
			return "Facebook";
		}
		
		protected override function get HasCloseButton():Boolean
		{
			return true;
		}
		
		// class
		public function Inviting4ChipsPopup(onClose:Function)
		{
			super(onClose);
			
			Main.Instance.XServices.Social.Invite();
			Main.Instance.XServices.Social.addEventListener(SocialEvent.InviteFriendsDialogComplete, OnInviteFriendsDialogComplete);
			Main.Instance.XServices.Social.addEventListener(SocialEvent.Failed, OnFailed);
		}
		
		protected override function AddBody():void
		{
			AddBlueMessageTextField(W, "Inviting");
			AddComponent(new Spacer(6));
			var androidLoader:AndroidLoader = new AndroidLoader(100, 100);
			androidLoader.x = (W - androidLoader.width) / 2;
			AddComponent(androidLoader);
		}
		
		public override function Dispose():void
		{
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.InviteFriendsDialogComplete, OnInviteFriendsDialogComplete);
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.Failed, OnFailed);
			
			super.Dispose();
		}
		
		// events
		protected function OnInviteFriendsDialogComplete(event:SocialEvent):void
		{
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.InviteFriendsDialogComplete, OnInviteFriendsDialogComplete);
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.Failed, OnFailed);
			
			var newInviteesCount:int = 0;
			var ids:Vector.<String> = event.IDs;
			for (var i:int = 0; i < ids.length; i++)
			{
				var inviteeInvited:Boolean = false;
				for (var j:int = 0; j < Main.Instance.Session.Rare.Invitees.length; j++)
				{
					if (ids[i] == Main.Instance.Session.Rare.Invitees[j])
					{
						inviteeInvited = true;
						break;
					}
				}
				
				if (!inviteeInvited)
				{
					Main.Instance.Session.Rare.Invitees.push(ids[i]);
					newInviteesCount++;
				}
			}
			
			SlotsNotificationsHandler.Instance.ShowInvited4ChipsPopup(newInviteesCount);
			DoRemove();
		}
		protected function OnFailed(event:Event):void
		{
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.InviteFriendsDialogComplete, OnInviteFriendsDialogComplete);
			Main.Instance.XServices.Social.removeEventListener(SocialEvent.Failed, OnFailed);
			
			DoRemove();
		}
		
		private function OnCancelClick(event:Event):void
		{
			DoRemove();
		}
	}
}