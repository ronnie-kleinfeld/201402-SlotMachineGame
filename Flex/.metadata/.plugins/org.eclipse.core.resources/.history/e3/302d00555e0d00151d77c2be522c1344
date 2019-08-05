package com.gotchaslots.common.ui.notifications.popup.shape
{
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	import com.gotchaslots.common.ui.common.components.gradientBG.RadialGradientBG;
	
	import flash.filters.GlowFilter;
	
	public class PopupBG extends BaseBG
	{
		// porperties
		protected override function get HasFrame():Boolean
		{
			return true;
		}
		protected override function get FrameColorHigh():Number
		{
			return 0xEC9EFE;
		}
		protected override function get FrameColorLow():Number
		{
			return 0xEC9EFE;
		}
		protected override function get FrameThickness():Number
		{
			return 2;
		}
		protected override function get FrameCorner():Number
		{
			return width * 0.1;
		}
		
		// class
		public function PopupBG(x:int, y:int, w:int, h:int)
		{
			super(w, h, 0x9439CE);
			
			filters = [new GlowFilter(0xEC9EFE, 1, 20, 20)];
			
			addChild(new RadialGradientBG(W, H, W * 0.1, 0xe7c0f7, 0x9436ce));
		}
	}
}