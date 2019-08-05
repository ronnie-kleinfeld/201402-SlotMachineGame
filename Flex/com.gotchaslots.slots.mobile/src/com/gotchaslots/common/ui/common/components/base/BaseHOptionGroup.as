package com.gotchaslots.common.ui.common.components.base
{
	public class BaseHOptionGroup extends BaseBG
	{
		// properties
		protected override function get FrameCorner():Number
		{
			return 15;
		}
		
		// class
		public function BaseHOptionGroup(w:int, h:int)
		{
			super(w - 24, h, 0x99ccff);
		}
	}
}