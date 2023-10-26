package com.gotchaslots.slots.data.machine.symbol.base
{
	import flash.display.Bitmap;
	
	public class BaseScatterSymbolData extends BaseSpecialSymbolData
	{
		// members
		private var _payboxPngClass:Class;
		private var _payboxesPng:Vector.<Bitmap>;
		
		// properties
		public function get PayboxPng():Bitmap
		{
			if (!_payboxesPng)
			{
				_payboxesPng = new Vector.<Bitmap>();
			}
			if (_payboxesPng.length == 0)
			{
				_payboxesPng.push(new _payboxPngClass());
			}
			return _payboxesPng.pop();
		}
		
		// class
		public function BaseScatterSymbolData(id:int, pngClass:Class, symbolType:String, factor:Number, fiveInARowPayout:Number, fourInARowPayout:Number, threeInARowPayout:Number, twoInARowPayout:Number, oneInARowPayout:Number, description:String, note:String, payboxPngClass:Class)
		{
			super(id, pngClass, symbolType, factor, fiveInARowPayout, fourInARowPayout, threeInARowPayout, twoInARowPayout, oneInARowPayout, description, note);
			
			_payboxPngClass = payboxPngClass;
		}
		
		// methods
		public function ReturnPayboxPng(bitmap:Bitmap):void
		{
			_payboxesPng.push(bitmap);
		}
	}
}