package com.gotchaslots.slots.data.machine.valuator.column
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	import com.gotchaslots.slots.data.machine.valuator.base.BaseValuatorsData;
	
	public class ColumnValuatorsData extends BaseValuatorsData
	{
		// members
		private var _columnValuators:Vector.<ColumnValuatorData>;
		
		// properteis
		public function get ColumnValuators():Vector.<ColumnValuatorData>
		{
			return _columnValuators;
		}
		
		// class
		public function ColumnValuatorsData()
		{
			super();
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			while (_columnValuators && _columnValuators.length > 0)
			{
				var columnValuator:ColumnValuatorData = _columnValuators.pop();
				columnValuator.Dispose();
				columnValuator = null;
			}
			_columnValuators = null;
		}
		
		// methods
		// columns are: ruled as horizontal payline but vertical
		public override function Evaluate(resultMatrix:BaseResultMatirxData):void
		{
			var symbols:Vector.<BaseSymbolData> = Main.Instance.ActiveMachine.LobbyMachine.Symbols.Symbols;
			var columnsCount:int = Main.Instance.ActiveMachine.LobbyMachine.Paylines.Paylines[0].ColumnsCount;
			
			_columnValuators = new Vector.<ColumnValuatorData>();
			
			var columnValuator:ColumnValuatorData;
			Payout = 0;
			for (var i:int = 0; i < columnsCount; i++)
			{
				var payboxes:Vector.<PayboxData> = resultMatrix.IsColumnValuable(i);
				columnValuator = new ColumnValuatorData(payboxes);
				if (payboxes.length > 0)
				{
					columnValuator.Payout = symbols[payboxes[0].ID].PayoutByHits(payboxes.length);
					_columnValuators.push(columnValuator);
				}
				
				Payout += columnValuator.Payout;
			}
		}
		public override function CalculatePaylinesPayout(selectedPaylines:int, selectedBetChips:Number):void
		{
			Payout = 0;
			Chips = 0;
			for (var i:int = 0; i < _columnValuators.length; i++)
			{
				_columnValuators[i].Chips = _columnValuators[i].Payout * selectedBetChips;
				Payout += _columnValuators[i].Payout;
				Chips += _columnValuators[i].Chips;
			}
		}
	}
}