package com.gotchaslots.slots.data.machine.valuator.collectibles
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.valuator.base.BaseScatterValuatorData;

	public class AceValuatorData extends BaseScatterValuatorData
	{
		// class
		public function AceValuatorData()
		{
			super(Main.Instance.ActiveMachine.LobbyMachine.Symbols.AceSymbol);
		}
	}
}