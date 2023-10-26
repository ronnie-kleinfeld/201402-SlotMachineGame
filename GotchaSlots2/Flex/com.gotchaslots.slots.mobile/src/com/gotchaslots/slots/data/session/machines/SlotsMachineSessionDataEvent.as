package com.gotchaslots.slots.data.session.machines
{
	import com.gotchaslots.common.data.session.machines.CommonMachineSessionData;
	import com.gotchaslots.common.data.session.machines.CommonMachineSessionDataEvent;
	
	public class SlotsMachineSessionDataEvent extends CommonMachineSessionDataEvent
	{
		// events
		public static const FreeSpinsSpinStarted:String = "5d5049db74a1440d804756611cfe1dc7";
		public static const FreeSpinsCollectCount:String = "4ca911922c6647029c206519879bfcc1";
		public static const FreeSpinsEndPopupClosed:String = "cb890e91a8814aa9ad9b0c300fa49ec4";
		
		public static const BonusGameChanged:String = "37bf2dd385014abb8626b5c0130e9573";
		public static const BonusGameWon:String = "06633e7d21204238907a5d3b1cc186b8";
		public static const BonusGameFinished:String = "4973cba29d1d40a4986a291d89090e38";
		
		// members
		private var _freeSpinsDiffCount:int;
		
		// properties
		public function get FreeSpinsDiffCount():int
		{
			return _freeSpinsDiffCount;
		}
		
		// class
		public function SlotsMachineSessionDataEvent(type:String, machineState:CommonMachineSessionData, freeSpinsDiffCount:int)
		{
			super(type, machineState);
			
			_freeSpinsDiffCount = freeSpinsDiffCount;
		}
	}
}