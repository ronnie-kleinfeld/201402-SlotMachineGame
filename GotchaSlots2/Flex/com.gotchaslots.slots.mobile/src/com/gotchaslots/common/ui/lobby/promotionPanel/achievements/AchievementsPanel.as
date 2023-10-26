package com.gotchaslots.common.ui.lobby.promotionPanel.achievements
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseTextField;
	
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	
	public class AchievementsPanel extends BaseTextField
	{
		// properties
		protected override function get BGFilters():Array
		{
			return [new DropShadowFilter(4, 45, 0x000000), new BevelFilter(3, 45, 0xffffff, 1, 0)];
		}
		
		protected override function get FrameCorner():Number
		{
			return 20;
		}
		
		protected override function get XFLTextField():TextField
		{
			return Main.Instance.TextFields.PopupTitle;
		}
		
		// class
		public function AchievementsPanel()
		{
			super(557, 124, "Coming soon..", null, 0x9436ce);
		}
	}
}