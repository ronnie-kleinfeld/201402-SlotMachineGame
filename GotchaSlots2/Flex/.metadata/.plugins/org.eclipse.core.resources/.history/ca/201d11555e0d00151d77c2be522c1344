package com.gotchaslots.common.data.session.machines
{
	import flash.events.Event;

	public class CommonMachineSessionDataEvent extends Event
	{
		// events
		public static const IsInvite4Unlocked:String = "0c01c6c559fa46dc96bdd4ffb2118ecf";
		
		public static const NewMachineChanged:String = "2bf3f94a10dc4eedb2970ee673ba9bfc";
		
		// members
		private var _machineState:CommonMachineSessionData;
		
		// properties
		public function get MachineState():CommonMachineSessionData
		{
			return _machineState;
		}
		
		// class
		public function CommonMachineSessionDataEvent(type:String, machineState:CommonMachineSessionData)
		{
			super(type, false, false);
			
			_machineState = machineState;
		}
	}
}