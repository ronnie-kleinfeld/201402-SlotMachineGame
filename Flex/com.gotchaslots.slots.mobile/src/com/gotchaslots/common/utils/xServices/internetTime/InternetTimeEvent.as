package com.gotchaslots.common.utils.xServices.internetTime
{
	import flash.events.Event;
	
	public class InternetTimeEvent extends Event
	{
		// consts
		public static const Connected:String = "1e2a7050532d4ad289d8bd272d326e99";
		
		// class
		public function InternetTimeEvent(type:String)
		{
			super(type);
		}
	}
}