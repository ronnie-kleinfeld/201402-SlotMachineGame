package com.gotchaslots.slots.data.machine.symbol
{
	import com.gotchaslots.slots.assets.machine.scatterPayboxes.ScatterPayboxesEmbed;
	import com.gotchaslots.slots.assets.machine.symbols.SymbolsEmbed;
	import com.gotchaslots.slots.data.machine.symbol.base.BaseScatterSymbolData;
	import com.gotchaslots.slots.data.machine.symbol.base.SymbolTypeEnum;
	
	public class BombSymbolData extends BaseScatterSymbolData
	{
		// properties
		public override function get SpecialOdds():Number
		{
			return 0.2 * _factor;
		}
		
		// class
		public function BombSymbolData(id:int, pngClass:Class, factor:Number)
		{
			super(id, SymbolsEmbed.Bomb, SymbolTypeEnum.Bomb, factor, 1, 1, 1, 1, 1, "Bomb", "The symbol explodes and the symbols will keep falling", ScatterPayboxesEmbed.Bomb);
		}
	}
}