package com.gotchaslots.slots.data.machine.valuator.scatter
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.valuator.base.BaseScatterValuatorData;
	
	public class FreeSpinsValuatorData extends BaseScatterValuatorData
	{
		// class
		public function FreeSpinsValuatorData()
		{
			super(Main.Instance.ActiveMachine.LobbyMachine.Symbols.FreeSpinsSymbol);
		}
	}
}