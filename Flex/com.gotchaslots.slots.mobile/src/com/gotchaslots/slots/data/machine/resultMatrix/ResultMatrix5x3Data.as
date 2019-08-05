package com.gotchaslots.slots.data.machine.resultMatrix
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	import com.gotchaslots.slots.data.machine.valuator.strike.StrikeValuatorData;
	
	public class ResultMatrix5x3Data extends BaseResultMatirxData
	{
		// properties
		protected override function get ResultMatrixLength():int
		{
			return 15;
		}
		
		// class
		public function ResultMatrix5x3Data(selectedPaylines:int, symbols:SymbolsData, paylines:BasePaylinesData)
		{
			super(selectedPaylines, symbols, paylines);
		}
		
		// methods
		public override function IsFiveInARow(strikeValuators:Vector.<StrikeValuatorData>):Boolean
		{
			for (var i:int = 0; i < strikeValuators.length; i++)
			{
				var strikeValuator:StrikeValuatorData = strikeValuators[i];
				if ((strikeValuator.Payline.ID == 0 || strikeValuator.Payline.ID == 1 || strikeValuator.Payline.ID == 2) && strikeValuator.Payboxes.length == 5)
				{
					return true;
				}
			}
			
			return false;
		}
		public override function IsFourInARow(strikeValuators:Vector.<StrikeValuatorData>):Boolean
		{
			for (var i:int = 0; i < strikeValuators.length; i++)
			{
				var strikeValuator:StrikeValuatorData = strikeValuators[i];
				if ((strikeValuator.Payline.ID == 0 || strikeValuator.Payline.ID == 1 || strikeValuator.Payline.ID == 2) && strikeValuator.Payboxes.length == 4)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public override function IsColumnValuable(columnID:int):Vector.<PayboxData>
		{
			var result:Vector.<PayboxData> = new Vector.<PayboxData>();
			
			var payboxes:Vector.<PayboxData> = Main.Instance.ActiveMachine.LobbyMachine.Paylines.Payboxes;
			
			if (_resultMatrix[columnID] == _resultMatrix[5 + columnID] &&
				_resultMatrix[columnID] == _resultMatrix[10 + columnID])
			{
				result.push(payboxes[columnID]);
				result.push(payboxes[5 + columnID]);
				result.push(payboxes[10 + columnID]);
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
				case 3:
				case 4:
					_resultMatrix[payboxID] = randomID;
					break;
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
					_resultMatrix[payboxID] = _resultMatrix[payboxID - 5];
					_resultMatrix[payboxID - 5] = randomID;
					break;
				case 10:
				case 11:
				case 12:
				case 13:
				case 14:
					_resultMatrix[payboxID] = _resultMatrix[payboxID - 5];
					_resultMatrix[payboxID - 5] = _resultMatrix[payboxID - 10];
					_resultMatrix[payboxID - 10] = randomID;
					break;
			}
			
			return randomID;
		}
	}
}