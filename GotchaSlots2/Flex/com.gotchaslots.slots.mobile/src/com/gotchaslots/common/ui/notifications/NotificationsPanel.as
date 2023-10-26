package com.gotchaslots.common.ui.notifications
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.ui.notifications.base.BaseNotification;
	import com.gotchaslots.common.ui.notifications.popup.ErrorPopup;
	import com.gotchaslots.common.ui.notifications.popup.base.BasePopup;
	import com.gotchaslots.common.ui.notifications.popup.buyChips.NoChargePopup;
	import com.greensock.TweenLite;
	import com.greensock.easing.CustomEase;
	
	import flash.events.Event;
	import com.gotchaslots.slots.ui.notifications.SlotsNotificationsHandler;
	
	public class NotificationsPanel extends SpriteEx
	{
		// memebrs
		private var _recentNotification:BaseNotification;
		private var _notifications:Vector.<BaseNotification>;
		
		// class
		public function NotificationsPanel()
		{
			super();
			
			SlotsNotificationsHandler.Instance.Init(this);
			_notifications = new Vector.<BaseNotification>();
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			while (_notifications && _notifications.length > 0)
			{
				var baseNotification:BaseNotification = _notifications.pop();
				TweenLite.killTweensOf(baseNotification);
				baseNotification.Dispose();
				baseNotification = null;
			}
		}
		
		// members
		public function Push(popup:BaseNotification, pushAsNextNotification:Boolean = false):void
		{
			if (_recentNotification && (_recentNotification is ErrorPopup && popup is ErrorPopup || _recentNotification is NoChargePopup && popup is NoChargePopup))
			{
				// error popups in a row, bypass
			}
			else
			{
				_recentNotification = popup;
				
				if (pushAsNextNotification)
				{
					_notifications.reverse();
					_notifications.push(popup);
					_notifications.reverse();
				}
				else
				{
					_notifications.push(popup);
				}
				
				CheckIfNotificationExists();
			}
		}
		private function CheckIfNotificationExists():void
		{
			if (_notifications.length > 0)
			{
				var notification:BaseNotification = _notifications[0];
				if (AddNotification(notification))
				{
					_notifications.splice(0, 1);
					notification.AddedToNotifications();
				}
			}
		}
		
		public function AddNotification(notification:BaseNotification):Boolean
		{
			if (numChildren == 0)
			{
				notification.addEventListener(Event.CLOSE, OnNotificationClose);
				
				addChild(notification);
				if (notification && notification is BasePopup)
				{
					if (notification.ShowSoundKey)
					{
						Main.Instance.Sounds.Play(notification.ShowSoundKey);
					}
					
					var yTo:Number = notification.y;
					notification.y = -Main.Instance.Device.DesignRectangle.height;
					
					CustomEase.create("popupEase", [{s:0,cp:0.252,e:0.636},{s:0.636,cp:1.02,e:0.994},{s:0.994,cp:0.968,e:1}]);
					TweenLite.to(notification, 0.5, {y:yTo, ease:CustomEase.byName("popupEase")});
				}
				
				return true;
			}
			
			return false;
		}
		public function RemoveNotifications():void
		{
			if (numChildren > 0)
			{
				var notification:BaseNotification = BaseNotification(getChildAt(0));
				if (notification.HideSoundKey)
				{
					Main.Instance.Sounds.Play(notification.HideSoundKey);
				}
				if (notification is BasePopup)
				{
					TweenLite.to(notification, 0.15, {alpha:0, onComplete:OnRemoveNotificationComplete, onCompleteParams:[notification]});
				}
				else
				{
					OnRemoveNotificationComplete(notification);
				}
			}
		}
		private function OnRemoveNotificationComplete(notification:BaseNotification):void
		{
			if (numChildren > 0 && contains(notification))
			{
				removeChild(notification);
			}
			notification.DoRemoved();
			
			CheckIfNotificationExists();
		}
		
		// events
		protected function OnNotificationClose(event:Event):void
		{
			var notification:BaseNotification = BaseNotification(event.currentTarget);
			notification.removeEventListener(Event.CLOSE, OnNotificationClose);
			RemoveNotifications();
		}
	}
}