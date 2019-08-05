package com.gotchaslots.slots.data.machine.valuator.base
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	
	public class BaseScatterValuatorData extends BaseValuatorData
	{
		// members
		private var _symbol:BaseSymbolData;
		
		// properties
		public function get Symbol():BaseSymbolData
		{
			return _symbol;
		}
		
		// class
		public function BaseScatterValuatorData(symbol:BaseSymbolData)
		{
			super();
			
			_symbol = symbol;
		}
		
		// methods
		public override function Evaluate(resultMatrix:BaseResultMatirxData):void
		{
			var payboxes:Vector.<PayboxData> = Main.Instance.ActiveMachine.LobbyMachine.Paylines.Payboxes;

			_payboxes = new Vector.<PayboxData>();
			for (var i:String in resultMatrix.ResultMatrix)
			{
				if (resultMatrix.ResultMatrix[i] == _symbol.ID)
				{
					_payboxes.push(payboxes[i]);
				}
			}
			
			Payout = _symbol.PayoutByHits(Payboxes.length);
		}
	}
}