package com.gotchaslots.common.utils.xServices.internetTime
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.MainEvent;
	import com.gotchaslots.common.utils.dataAdapter.api.GetTimeApi;
	import com.gotchaslots.common.utils.dataAdapter.manager.DataAdapterHandler;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	public class InternetTimeHandler extends EventDispatcherEx
	{
		// members
		private var _dataAdapter:DataAdapterHandler;
		private var _initialUTCMS:Number;
		private var _currentUTCMS:Number;
		
		// properties
		public function get IsInternetTime():Boolean
		{
			return _initialUTCMS != -1;
		}
		
		public function get InitialUTCMS():Number
		{
			return _initialUTCMS;
		}
		public function get CurrentLocalMS():Number
		{
			var dt:Date = new Date();
			if (Main.Instance.XServices.InternetTime.IsInternetTime)
			{
				return _currentUTCMS - dt.timezoneOffset * 60 * 1000;
			}
			else
			{
				return dt.time - dt.timezoneOffset * 60 * 1000;
			}
		}
		
		public function get InitialDateTime():Date
		{
			return new Date(null, null, null, null, null, null, InitialUTCMS);
		}
		public function get CurrentLocalDateTime():Date
		{
			return new Date(null, null, null, null, null, null, CurrentLocalMS);
		}
		
		private function set MS(value:Number):void
		{
			if (_initialUTCMS == -1)
			{
				_initialUTCMS = value;
			}
			
			_currentUTCMS = value;
			
			Main.Instance.Session.Rare.RegistrationMS = _currentUTCMS;
		}
		
		// class
		public function InternetTimeHandler()
		{
			InitMS();
			UpdateMS();
			
			Main.Instance.addEventListener(MainEvent.Timer, OnTimer);
			
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE ,OnNetworkChange);
		}
		private function InitMS():void
		{
			_initialUTCMS = -1;
			MS = -1;
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			Main.Instance.removeEventListener(MainEvent.Timer, OnTimer);
		}
		
		// methods
		public function UpdateMS():void
		{
			_dataAdapter = new DataAdapterHandler();
			_dataAdapter.AddApi(new GetTimeApi());
			_dataAdapter.addEventListener(Event.COMPLETE, OnDataAdapterComplete);
			_dataAdapter.addEventListener(DataAdapterHandler.ServerError, OnDataAdapterServerError);
			_dataAdapter.Execute();
		}
		
		// events
		protected function OnTimer(event:Event):void
		{
			if (_currentUTCMS > 0)
			{
				_currentUTCMS = _currentUTCMS + 1000;
			}
		}
		
		protected function OnDataAdapterComplete(event:Event):void
		{
			try
			{
				_dataAdapter.removeEventListener(DataAdapterHandler.ServerError, OnDataAdapterServerError);
				_dataAdapter.removeEventListener(Event.COMPLETE, OnDataAdapterComplete);
				
				var utcTime:String = _dataAdapter.GetResponse(GetTimeApi.URL);
				// http://www.timeapi.org//utc/now
				// 2014-02-28T11:54:00+00:00
				
				var date:Array = utcTime.split("T")[0].split("-");					// 2014-02-28
				var time:Array = utcTime.split("T")[1].split("+")[0].split(":");	// 11:54:00
				var dt:Date = new Date(date[0], int(date[1]) - 1, date[2], time[0], time[1], time[2]);
				dt.hoursUTC = time[0];
				
				MS = dt.time + 2209075200000; // add milliseconds between 1900->1970
				
				dispatchEvent(new InternetTimeEvent(InternetTimeEvent.Connected));
			}
			catch (error:Error)
			{
				InitMS();
			}
		}
		protected function OnDataAdapterServerError(event:Event):void
		{
			_dataAdapter.removeEventListener(DataAdapterHandler.ServerError, OnDataAdapterServerError);
			_dataAdapter.removeEventListener(Event.COMPLETE, OnDataAdapterComplete);
			
			InitMS();
		}
		
		protected function OnNetworkChange(event:Event):void
		{
			UpdateMS();
		}
	}
}