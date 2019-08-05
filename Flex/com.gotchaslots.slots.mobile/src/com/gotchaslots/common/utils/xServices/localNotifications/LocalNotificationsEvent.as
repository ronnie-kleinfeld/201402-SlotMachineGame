package com.gotchaslots.common.utils.xServices.localNotifications
{
	import flash.events.Event;

	public class LocalNotificationsEvent extends Event
	{
		// consts
		public static const LOCAL_NOTIFICATION_RECEIVED:String = "LOCAL_NOTIFICATION_RECEIVED";
		public static const RESUMED_FROM_LOCAL_NOTIFICATION:String = "RESUMED_FROM_LOCAL_NOTIFICATION";

		// members
		private var _title:String;
		private var _message:String;
		private var _extra:Object;
		private var _extraJson:String;

		// properties
		public function Title():String
		{
			return _title;
		}
		public function Message():String
		{
			return _message;
		}
		public function Extra():Object
		{
			return _extra;
		}
		public function ExtraJson():String
		{
			return _extraJson;
		}
		
		// class
		public function LocalNotificationsEvent(type:String, title:String, message:String, extra:Object, extraJson:String)
		{
			super(type);
			
			_title = title;
			_message = message;
			_extra = extra;
			_extraJson = extraJson;
		}
	}
}