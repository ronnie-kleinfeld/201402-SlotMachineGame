package com.gotchaslots.common.ui.common.components.base
{
	import flash.display.Bitmap;
	import flash.filters.BevelFilter;
	
	public class BasePng extends BaseBG
	{
		// members
		private var _normalPng:Bitmap;
		
		// properties
		protected function get NormalPng():Bitmap
		{
			return _normalPng;
		}
		protected function get PngFilters():Array
		{
			return [new BevelFilter(3, 45, 0xffffff, 1, 0)];
		}
		
		// class
		public function BasePng(w:int, h:int, normalPng:Bitmap = null, bgColor:Number = Number.NaN)
		{
			super(w, h, bgColor);
			
			AddNormalPng(normalPng);
		}
		private function AddNormalPng(normalPng:Bitmap):void
		{
			if (normalPng)
			{
				_normalPng = normalPng;
				_normalPng.smoothing = true;
				_normalPng.scaleX = width / _normalPng.width;
				_normalPng.scaleY = height / _normalPng.height;
				_normalPng.x = (width - _normalPng.width) / 2;
				_normalPng.y = (height - _normalPng.height) / 2;
				_normalPng.filters = PngFilters;
				if (_frame)
				{
					addChildAt(_normalPng, getChildIndex(_frame));
				}
				else
				{
					addChild(_normalPng);
				}
			}
		}
	}
}