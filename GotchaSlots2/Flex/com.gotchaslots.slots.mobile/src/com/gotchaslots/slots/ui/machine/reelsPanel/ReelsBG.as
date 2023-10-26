package com.gotchaslots.slots.ui.machine.reelsPanel
{
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.common.ui.common.components.gradientBG.RadialGradientBG;
	
	public class ReelsBG extends BasePng
	{
		// properteis
		protected override function get PngFilters():Array
		{
			return null;
		}
		
		// class
		public function ReelsBG()
		{
			super(800, 306);
			
			addChild(new RadialGradientBG(W, H, 0, 0xe7c0f7, 0x00121E));
		}
	}
}