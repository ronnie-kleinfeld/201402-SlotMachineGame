package com.gotchaslots.slots.ui.notifications
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.notifications.CommonNotificationsHandler;
	import com.gotchaslots.slots.ui.notifications.popup.bonusGame.BonusGameEndPopup;
	import com.gotchaslots.slots.ui.notifications.popup.bonusGame.BonusGameStartPopup;
	import com.gotchaslots.slots.ui.notifications.popup.machine.FreeSpinsEndPopup;
	
	public class SlotsNotificationsHandler extends CommonNotificationsHandler
	{
		// singleton
		private static var _instance:SlotsNotificationsHandler;
		public static function get Instance():SlotsNotificationsHandler
		{
			if (_instance == null)
			{
				_instance = new SlotsNotificationsHandler();
			}
			
			return _instance;
		}
		
		// class
		public function SlotsNotificationsHandler()
		{
			super();
		}
		
		// popups
		public function ShowBonusGameEndPopup(chips:Number, onClose:Function):void
		{
			_notificationsPanel.Push(new BonusGameEndPopup(chips, onClose));
		}
		public function ShowBonusGameStartPopup(onClose:Function):void
		{
			_notificationsPanel.Push(new BonusGameStartPopup(onClose));
		}
		public function ShowFreeSpinsEndPopup(onClose:Function):void
		{
			if (Main.Instance.ActiveMachine)
			{
				_notificationsPanel.Push(new FreeSpinsEndPopup(onClose));
			}
		}
	}
}