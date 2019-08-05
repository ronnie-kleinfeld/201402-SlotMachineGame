package com.gotchaslots.slots.data.machine.resultMatrix
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	import com.gotchaslots.slots.data.machine.valuator.strike.StrikeValuatorData;
	
	public class ResultMatrix3x3Data extends BaseResultMatirxData
	{
		// properties
		protected override function get ResultMatrixLength():int
		{
			return 9;
		}
		
		// class
		public function ResultMatrix3x3Data(selectedPaylines:int, symbols:SymbolsData, paylines:BasePaylinesData)
		{
			super(selectedPaylines, symbols, paylines);
		}
		
		// methods
		public override function IsFiveInARow(strikeValuators:Vector.<StrikeValuatorData>):Boolean
		{
			return false;
		}
		public override function IsFourInARow(strikeValuators:Vector.<StrikeValuatorData>):Boolean
		{
			return false;
		}
		
		public override function IsColumnValuable(columnID:int):Vector.<PayboxData>
		{
			var result:Vector.<PayboxData> = new Vector.<PayboxData>();
			
			var payboxes:Vector.<PayboxData> = Main.Instance.ActiveMachine.LobbyMachine.Paylines.Payboxes;
			
			if (_resultMatrix[columnID] == _resultMatrix[3 + columnID] &&
				_resultMatrix[columnID] == _resultMatrix[6 + columnID])
			{
				result.push(payboxes[columnID]);
				result.push(payboxes[3 + columnID]);
				result.push(payboxes[6 + columnID]);
			}
			
			return result;
		}
		
		public override function Gravity(payboxID:int):int
		{
			var randomID:int = _symbols.RandomNormalID;
			
			switch (payboxID)
			{
				case 0:
				case 1:
				case 2:
					_resultMatrix[payboxID] = randomID;
					break;
				case 3:
				case 4:
				case 5:
					_resultMatrix[payboxID] = _resultMatrix[payboxID - 3];
					_resultMatrix[payboxID - 3] = randomID;
					break;
				case 6:
				case 7:
				case 8:
					_resultMatrix[payboxID] = _resultMatrix[payboxID - 3];
					_resultMatrix[payboxID - 3] = _resultMatrix[payboxID - 6];
					_resultMatrix[payboxID - 6] = randomID;
					break;
			}
			
			return randomID;
		}
	}
}