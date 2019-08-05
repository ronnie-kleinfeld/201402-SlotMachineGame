package com.gotchaslots.slots.data.machine.symbol
{
	import com.gotchaslots.slots.assets.machine.symbols.SymbolsEmbed;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseSpecialSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.base.SymbolTypeEnum;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	public class WildSymbolData extends BaseSpecialSymbolData
	{
		// properties
		public override function get SpecialOdds():Number
		{
			return 0.25 * _factor;
		}
		
		// class
		public function WildSymbolData(id:int, pngClass:Class, factor:Number)
		{
			var note:String = "";
			if (100 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(5, 0, 0) + " - " + FormatterHelper.NumberToMoney(100 * factor, 0, 0) + " Chips\n";
			}
			if (50 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(4, 0, 0) + " - " + FormatterHelper.NumberToMoney(50 * factor, 0, 0) + " Chips\n";
			}
			if (20 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(3, 0, 0) + " - " + FormatterHelper.NumberToMoney(20 * factor, 0, 0) + " Chips\n";
			}
			if (10 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(2, 0, 0) + " - " + FormatterHelper.NumberToMoney(10 * factor, 0, 0) + " Chips";
			}
			
			super(id, SymbolsEmbed.Wild, SymbolTypeEnum.Wild, factor, 20 * factor, 15 * factor, 10 * factor, 5 * factor, 0, "Wild", note);
		}
	}
}