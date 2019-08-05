package com.gotchaslots.slots.data.machine.valuator.strike
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.slots.data.machine.resultMatrix.base.BaseResultMatirxData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.base.SymbolTypeEnum;
	import com.gotchaslots.slots.data.machine.valuator.base.BaseValuatorsData;
	
	public class StrikeValuatorsData extends BaseValuatorsData
	{
		// members
		private var _strikeValuators:Vector.<StrikeValuatorData>;
		
		private var _isFiveInARow:Boolean;
		private var _isFourInARow:Boolean;
		
		// properteis
		public function get StrikeValuators():Vector.<StrikeValuatorData>
		{
			return _strikeValuators;
		}
		
		public function get IsMegaWin():Boolean
		{
			return Payout > 20;
		}
		public function get IsExtraBigWin():Boolean
		{
			return Payout > 15;
		}
		public function get IsBigWin():Boolean
		{
			return Payout > 10;
		}
		public function get IsFiveInARow():Boolean
		{
			return _isFiveInARow;
		}
		public function get IsFourInARow():Boolean
		{
			return _isFourInARow;
		}
		public function get IsNormalWin():Boolean
		{
			return Payout > 0;
		}
		
		// class
		public function StrikeValuatorsData()
		{
			super();
		}
		public override function Dispose():void
		{
			super.Dispose();
			
			while (_strikeValuators && _strikeValuators.length > 0)
			{
				var strikeValuator:StrikeValuatorData = _strikeValuators.pop();
				strikeValuator.Dispose();
				strikeValuator = null;
			}
			_strikeValuators = null;
		}
		
		// methods
		public override function Evaluate(resultMatrix:BaseResultMatirxData):void
		{
			_strikeValuators = new Vector.<StrikeValuatorData>();
			
			for (var i:int = 0; i < Main.Instance.ActiveMachine.LobbyMachine.Paylines.Paylines.length; i++)
			{
				var payline:BasePaylineData = Main.Instance.ActiveMachine.LobbyMachine.Paylines.Paylines[i];
				var payboxes:Vector.<PayboxData> = new Vector.<PayboxData>();
				var symbols:Vector.<BaseSymbolData> = new Vector.<BaseSymbolData>();
				
				/*
				var str:String = payline.ID.toString();
				var dic:Dictionary = resultMatrix.ResultMatrix;
				for (var j:int = 0; j < payline.Payboxes.length; j++)
				{
				str += " " + payline.Payboxes[j].ID;
				}
				str += "\t";
				for (var j:int = 0; j < payline.Payboxes.length; j++)
				{
				str += " " + dic[payline.Payboxes[j].ID];
				}
				*/
				
				payboxes.push(payline.Payboxes[0]);
				var symbol0ID:int = resultMatrix.ResultMatrix[payboxes[0].ID];
				var symbol0:BaseSymbolData = Main.Instance.ActiveMachine.LobbyMachine.Symbols.Symbols[symbol0ID];
				symbols.push(symbol0);
				
				if (symbol0.SymbolType == SymbolTypeEnum.Normal || symbol0.SymbolType == SymbolTypeEnum.Wild)
				{
					var normalSymbol:BaseSymbolData = symbol0.SymbolType == SymbolTypeEnum.Normal ? symbol0 : null;
					for (var j:int = 1; j < payline.Payboxes.length; j++)
					{
						var paybox:PayboxData = payline.Payboxes[j];
						var symbolID:int = resultMatrix.ResultMatrix[paybox.ID];
						var symbol:BaseSymbolData = Main.Instance.ActiveMachine.LobbyMachine.Symbols.Symbols[symbolID];
						
						if (symbol.SymbolType == SymbolTypeEnum.Normal)
						{
							if (!normalSymbol)
							{
								normalSymbol = symbol;
								payboxes.push(paybox);
								symbols.push(symbol);
							}
							else if (normalSymbol && normalSymbol.ID == symbol.ID)
							{
								payboxes.push(paybox);
								symbols.push(symbol);
							}
							else
							{
								break;
							}
						}
						else if (symbol.SymbolType == SymbolTypeEnum.Wild)
						{
							payboxes.push(paybox);
							symbols.push(symbol);
						}
						else
						{
							break;
						}
					}
					
					/*
					if (payboxes.length >= 3)
					{
					var str:String = "";
					}
					*/
				}
				else
				{
					payboxes.pop();
					symbols.pop();
				}

				var strikeValuator:StrikeValuatorData = new StrikeValuatorData(payboxes, payline, symbols);
				strikeValuator.Payout = symbol0.PayoutByHits(payboxes.length);
				_strikeValuators.push(strikeValuator);

				/*
				var str:String = payline.ID + "\t";
				var dic:Dictionary = resultMatrix.ResultMatrix;
				for (var j:int = 0; j < payboxes.length; j++)
				{
				str += " " + dic[payboxes[j].ID];
				}
				trace(str);
				*/
			}
			
			_isFiveInARow = resultMatrix.IsFiveInARow(_strikeValuators);
			_isFourInARow = resultMatrix.IsFourInARow(_strikeValuators);
			
			/*
			// debug validate valuators
			var dic:Dictionary = resultMatrix.ResultMatrix;
			trace(" 0", " 1", " 2", " 3", " 4", "\t", dic[0], dic[1], dic[2], dic[3], dic[4]);
			trace(" 5", " 6", " 7", " 8", " 9", "\t", dic[5], dic[6], dic[7], dic[8], dic[9]);
			trace("10", "11", "12", "13", "14", "\t", dic[10], dic[11], dic[12], dic[13], dic[14]);
			
			if (_strikeValuators.length > 0)
			{
			for (i = 0; i < _strikeValuators.length; i++)
			{
			var description:String = "";
			var payboxIDs:String = "";
			for (j = 0; j < _strikeValuators[i].Payboxes.length; j++)
			{
			var paybox:PayboxData = _strikeValuators[i].Payboxes[j];
			var symbolID:int = resultMatrix.ResultMatrix[paybox.ID];
			var symbol:BaseSymbolData = symbols[symbolID];
			
			description += symbol.Description + ",";
			payboxIDs += paybox.ID + ",";
			}
			
			trace(_strikeValuators[i].ID, _strikeValuators[i].IsValuable, _strikeValuators[i].Chips, _strikeValuators[i].Payout, _strikeValuators[i].Payline.ID, description, payboxIDs);
			}
			}
			else
			{
			trace("none");
			}
			*/
		}
		public override function CalculatePaylinesPayout(selectedPaylines:int, selectedBetChips:Number):void
		{
			Payout = 0;
			Chips = 0;
			for (var i:int = 0; i < selectedPaylines; i++)
			{
				_strikeValuators[i].Chips = _strikeValuators[i].Payout * selectedBetChips;
				Payout += _strikeValuators[i].Payout;
				Chips += _strikeValuators[i].Chips;
			}
		}
	}
}