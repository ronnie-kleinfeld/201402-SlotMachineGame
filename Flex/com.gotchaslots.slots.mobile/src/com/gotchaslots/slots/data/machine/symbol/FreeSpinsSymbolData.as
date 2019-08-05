package com.gotchaslots.slots.data.machine.symbol
{
	import com.gotchaslots.slots.assets.machine.scatterPayboxes.ScatterPayboxesEmbed;
	import com.gotchaslots.slots.assets.machine.symbols.SymbolsEmbed;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseScatterSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.base.SymbolTypeEnum;
	import com.gotchaslots.common.utils.helpers.FormatterHelper;
	
	public class FreeSpinsSymbolData extends BaseScatterSymbolData
	{
		// properties
		public override function get PayoutSum():Number
		{
			var result:Number = OneInARowPayout + TwoInARowPayout + ThreeInARowPayout + FourInARowPayout + FiveInARowPayout;
			return result < 1 ? 1 : result;	
		}
		public override function get SpecialOdds():Number
		{
			return 0.05 * _factor;
		}
		
		// class
		public function FreeSpinsSymbolData(id:int, pngClass:Class, factor:Number)
		{
			var note:String = "";
			if (25 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(5, 0, 0) + " - " + FormatterHelper.NumberToMoney(25 * factor, 0, 0) + " " + "Free Spins\n";
			}
			if (15 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(4, 0, 0) + " - " + FormatterHelper.NumberToMoney(15 * factor, 0, 0) + " " + "Free Spins\n";
			}
			if (8 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(3, 0, 0) + " - " + FormatterHelper.NumberToMoney(8 * factor, 0, 0) + " " + "Free Spins\n";
			}
			if (5 * factor > 0)
			{
				note += FormatterHelper.NumberToMoney(2, 0, 0) + " - " + FormatterHelper.NumberToMoney(5 * factor, 0, 0) + " " + "Free Spins";
			}
			
			super(id, SymbolsEmbed.FreeSpins, SymbolTypeEnum.FreeSpins, factor, 7 * factor, 5 * factor, 3 * factor, 2 * factor, 0, "Free Spins", note, ScatterPayboxesEmbed.FreeSpins);
		}
	}
}