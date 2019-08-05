package com.gotchaslots.common.ui.hud
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.SpriteEx;
	import com.gotchaslots.common.ui.hud.jackpot.JackpotRibbon;
	import com.gotchaslots.common.ui.hud.tickerPanel.TickerPanel;
	import com.gotchaslots.common.ui.hud.topPanel.TopPanel;
	
	public class HudPanel extends SpriteEx
	{
		// class
		public function HudPanel()
		{
			super();
			
			// jackpot
			var jackpot:JackpotRibbon = new JackpotRibbon();
			jackpot.x = (Main.Instance.Device.DesignRectangle.width - jackpot.width) / 2;
			jackpot.y = 28;
			addChild(jackpot);
			
			// top panel
			addChild(new TopPanel());
			
			// ticker panel
			var tickerPanel:TickerPanel = new TickerPanel();
			tickerPanel.x = (Main.Instance.Device.DesignRectangle.width - tickerPanel.width) / 2;
			tickerPanel.y = 330;
			addChild(tickerPanel);
			
			// frame
			//addChild(new HudFrame());
		}
	}
}