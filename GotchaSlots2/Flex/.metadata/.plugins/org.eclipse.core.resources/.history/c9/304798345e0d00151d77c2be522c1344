package com.gotchaslots.slots.data.machine.resultMatrix
{
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.paylines.base.BasePaylinesData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.SymbolsData;
	import com.gotchaslots.slots.data.machine.valuator.strike.StrikeValuatorData;
	
	public class ResultMatrix5x1Data extends BaseResultMatirxData
	{
		// properties
		protected override function get ResultMatrixLength():int
		{
			return 5;
		}
		
		// class
		public function ResultMatrix5x1Data(selectedPaylines:int, symbols:SymbolsData, paylines:BasePaylinesData)
		{
			super(selectedPaylines, symbols, paylines);
		}
		
		// methods
		public override function IsFiveInARow(strikeValuators:Vector.<StrikeValuatorData>):Boolean
		{
			for (var i:int = 0; i < strikeValuators.length; i++)
			{
				var strikeValuator:StrikeValuatorData = strikeValuators[i];
				if (strikeValuator.Payline.ID == 0 && strikeValuator.Payboxes.length == 5)
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
				if (strikeValuator.Payline.ID == 0 && strikeValuator.Payboxes.length == 4)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public override function IsColumnValuable(columnID:int):Vector.<PayboxData>
		{
			var result:Vector.<PayboxData> = new Vector.<PayboxData>();
			return result;
		}
		
		public override function Gravity(payboxID:int):int
		{
			var randomID:int = _symbols.RandomNormalID;
			_resultMatrix[payboxID] = randomID;
			return randomID;
		}
	}
}