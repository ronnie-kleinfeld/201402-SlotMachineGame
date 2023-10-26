package com.gotchaslots.slots.data.machine.valuator.strike
{
	import com.gotchaslots.slots.data.machine.paybox.PayboxData;
	import com.gotchaslots.slots.data.machine.paylines.payline.base.BasePaylineData;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSymbolData;
	import com.gotchaslots.slots.data.machine.valuator.base.BasePaylineValuatorData;
	
	public class StrikeValuatorData extends BasePaylineValuatorData
	{
		// members
		protected var _symbols:Vector.<BaseSymbolData>;
		
		// properteis
		public function get Symbols():Vector.<BaseSymbolData>
		{
			return _symbols;
		}
		
		// class
		public function StrikeValuatorData(payboxes:Vector.<PayboxData>, payline:BasePaylineData, symbols:Vector.<BaseSymbolData>)
		{
			super();
			
			_payboxes = payboxes;
			_payline = payline;
			_symbols = symbols;
		}
	}
}