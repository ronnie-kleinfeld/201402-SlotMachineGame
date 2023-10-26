package com.gotchaslots.common.ui.lobby.promotionPanel
{
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	import com.gotchaslots.common.ui.common.components.gradientBG.RotatedGradientBG;
	import com.gotchaslots.common.ui.lobby.promotionPanel.achievements.AchievementsPanel;
	import com.gotchaslots.common.ui.lobby.promotionPanel.timerBonus.TimerBonusPanel;
	
	public class PromotionPanel extends BaseBG
	{
		// members
		private var _timerBonus:TimerBonusPanel;
		
		// class
		public function PromotionPanel()
		{
			super(800, 140);
			
			// gradient bg
			addChild(new RotatedGradientBG(W, H, 0, 0xbf5deb, 0xa823e0));
			
			InitAchievementsPanel();
			InitTimerBonusPanel();
		}
		private function InitAchievementsPanel():void
		{
			var achievements:AchievementsPanel = new AchievementsPanel();
			achievements.x = 8;
			achievements.y = 8;
			addChild(achievements);
		}
		private function InitTimerBonusPanel():void
		{
			_timerBonus = new TimerBonusPanel(219, 124);
			_timerBonus.x = 573;
			_timerBonus.y = 8;
			addChild(_timerBonus);
		}
		
		// methods
		public function Start():void
		{
			_timerBonus.Start();
		}
		public function Stop():void
		{
			_timerBonus.Stop();
		}
	}
}