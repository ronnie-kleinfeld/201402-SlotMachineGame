package com.gotchaslots.slots.data.machine.symbol
{
	import com.gotchaslots.slots.assets.machine.scatterPayboxes.ScatterPayboxesEmbed;
	import com.gotchaslots.slots.assets.machine.symbols.SymbolsEmbed;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseScatterSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.base.SymbolTypeEnum;
	
	public class MiniSpinSymbolData extends BaseScatterSymbolData
	{
		// properties
		public override function get SpecialOdds():Number
		{
			return 0.2 * _factor;
		}
		
		// class
		public function MiniSpinSymbolData(id:int, pngClass:Class, factor:Number)
		{
			super(id, SymbolsEmbed.MiniSpin, SymbolTypeEnum.MiniSpin, factor, 1, 1, 1, 1, 1, "MiniSpin", "The symbol will spin for a second chance to win", ScatterPayboxesEmbed.MiniSpin);
		}
	}
}