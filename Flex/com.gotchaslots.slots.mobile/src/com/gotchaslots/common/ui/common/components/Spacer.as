package com.gotchaslots.common.ui.common.components
{
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	
	import flash.display.Shape;
	
	public class Spacer extends BasePng
	{
		// class
		public function Spacer(size:int)
		{
			super(size, size, null, Number.NaN);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0, 0);
			shape.graphics.drawRect(0, 0, size, size);
			shape.graphics.endFill();
			addChild(shape);
		}
	}
}