package com.gotchaslots.common.ui.main
{
	import com.gotchaslots.common.ui.common.components.base.BasePng;
	import com.gotchaslots.slots.assets.common.SlotsEmbed;
	
	public class SplashBG extends BasePng
	{
		// properties
		protected override function get PngFilters():Array
		{
			return null;
		}
		
		// class
		public function SplashBG()
		{
			super(800, 494, new SlotsEmbed.Splash800x494(), 0);
		}
	}
}