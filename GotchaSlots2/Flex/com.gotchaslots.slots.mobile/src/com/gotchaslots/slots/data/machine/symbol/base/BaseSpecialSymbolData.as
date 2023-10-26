package com.gotchaslots.slots.data.machine.symbol.base
{
	public class BaseSpecialSymbolData extends BaseSymbolData
	{
		// properties
		public function get SpecialOdds():Number
		{
			return 0.02 * _factor;
		}
		public function get IsRandomOdds():Boolean
		{
			var rnd:Number = Math.random();
			return Math.floor(Math.random() * (1 / SpecialOdds)) == 0;
		}
		
		// class
		public function BaseSpecialSymbolData(id:int, pngClass:Class, symbolType:String, factor:Number, fiveInARowPayout:Number, fourInARowPayout:Number, threeInARowPayout:Number, twoInARowPayout:Number, oneInARowPayout:Number, description:String, note:String)
		{
			super(id, pngClass, symbolType, factor, fiveInARowPayout, fourInARowPayout, threeInARowPayout, twoInARowPayout, oneInARowPayout, description, note);
		}
	}
}