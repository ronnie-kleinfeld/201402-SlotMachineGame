package com.gotchaslots.common.ui.common.components.gradientBG
{
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	public class ProgressBarGradientBG extends BaseComponent
	{
		// class
		public function ProgressBarGradientBG(w:int, h:int)
		{
			super(w, h);
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(H / 2, H / 2, Math.PI / 2, 0, 0);
			
			this.graphics.beginGradientFill(GradientType.LINEAR, [0x833102, 0xfefe00], [1, 1], [0, 255], matrix, SpreadMethod.REFLECT);        
			this.graphics.drawRect(0, 0, W, H);
		}
	}
}