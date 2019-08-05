package com.gotchaslots.common.utils.helpers
{
	import flash.display.Shape;
	
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	
	public class MarkerRectHelper extends SpriteEx
	{
		public static function CreateShape(x:Number, y:Number, width:Number, height:Number):Shape
		{
			var maskingShape:Shape = new Shape();
			maskingShape.graphics.lineStyle(1, 0xff0000, 0.8);
			maskingShape.graphics.beginFill(0x00ffff, 0.2);
			maskingShape.graphics.drawRect(x, y, width - 1, height - 1);
			maskingShape.graphics.endFill();
			return maskingShape;
		}
	}
}