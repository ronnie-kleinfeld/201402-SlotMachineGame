package com.gotchaslots.common.data
{
	import flash.events.Event;
	
	public class MainEvent extends Event
	{
		// events
		public static const Timer:String = "e053bed955c848c7b6a0b56dd3a934e6";
		
		public static const ActiveMachineDataCreated:String = "a6f23d3703a043a8be83b925efb7ecfe";
		public static const RemoveActiveMachineView:String = "fd6341fb482b4291925eba20fbd5fa87";
		
		// class
		public function MainEvent(type:String)
		{
			super(type, false, false);
		}
	}
}