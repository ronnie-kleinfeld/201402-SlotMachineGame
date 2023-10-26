package com.gotchaslots.common.utils.xServices.deviceID
{
	public class DeviceIDHandler
	{
		// properties
		public function get DeviceID():String
		{
			return int(Math.random() * 100000000).toString();
		}
		
		// clss
		public function DeviceIDHandler()
		{
		}
	}
}