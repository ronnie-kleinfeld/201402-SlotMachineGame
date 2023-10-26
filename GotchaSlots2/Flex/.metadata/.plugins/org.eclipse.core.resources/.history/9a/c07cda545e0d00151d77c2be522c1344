package com.gotchaslots.common.ui.common.components.gradientBG
{
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public class RotatedGradientBG extends BaseComponent
	{
		// class
		public function RotatedGradientBG(w:int, h:int, corner:Number, color1:Number, color2:Number)
		{
			super(w, h);
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(20, 20, 0.50, 0, 0);
			
			this.graphics.beginGradientFill(GradientType.LINEAR, [color1, color2], [1, 1], [0, 255], matrix, SpreadMethod.REFLECT);        
			this.graphics.drawRoundRect(0, 0, W, H, corner);
		}
	}
}