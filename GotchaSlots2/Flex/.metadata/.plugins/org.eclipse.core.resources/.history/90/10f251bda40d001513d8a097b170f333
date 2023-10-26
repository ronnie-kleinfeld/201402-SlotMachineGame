package com.gotchaslots.common.utils.xServices.nativeDialogs.credentialsDialog
{
	import flash.events.Event;

	public class CredentialsDialogEvent extends Event
	{
		// consts
		public static const OK:String = "OK";
		public static const CANCEL:String = "CANCEL";
		
		// members
		private var _name:String;
		private var _password:String;
		
		// properties
		public function get Name():String
		{
			return _name;
		}
		public function get Password():String
		{
			return _password;
		}
		
		// class
		public function CredentialsDialogEvent(type:String, name:String, password:String)
		{
			super(type);
			
			_name = name;
			_password = password;
		}
	}
}