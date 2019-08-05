package com.gotchaslots.common.ui.hud.topPanel
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.data.session.SessionDataEvent;
	import com.gotchaslots.common.ui.common.components.base.BaseComponent;
	import com.gotchaslots.common.ui.common.components.gradientBG.RotatedGradientBG;
	import com.gotchaslots.common.ui.common.progressBar.ProgressBar;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.BuyChipsButton;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.BuyChipsTimerRibbon;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.ChipsButton;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.FacebookButton;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.HomeButton;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.SettingsButton;
	import com.gotchaslots.common.ui.hud.topPanel.buttons.VolumeTopBarButton;
	import com.gotchaslots.common.ui.hud.topPanel.textFields.BalanceTextField;
	import com.gotchaslots.common.ui.hud.topPanel.textFields.LevelInfoTextField;
	import com.gotchaslots.common.ui.hud.topPanel.textFields.XPProgressTextField;
	
	import flash.events.Event;
	
	public class TopPanel extends BaseComponent
	{
		// members
		private var _progressVar:ProgressBar;
		
		// class
		public function TopPanel()
		{
			super(800, 48);
			
			InitComponents();
		}
		private function InitComponents():void
		{
			// gradient bg
			addChild(new RotatedGradientBG(W, H, 0, 0xbf5deb, 0xa823e0));
			
			// BuyChipsTimerRibbon
			var buyChipsTimerRibbon:BuyChipsTimerRibbon = new BuyChipsTimerRibbon();
			buyChipsTimerRibbon.x = 73;
			buyChipsTimerRibbon.y = 20;
			addChild(buyChipsTimerRibbon);
			
			// balance
			var balanceTextField:BalanceTextField = new BalanceTextField();
			balanceTextField.x = 68;
			balanceTextField.y = 9;
			addChild(balanceTextField);
			
			// chips
			var chips:ChipsButton = new ChipsButton();
			chips.x = 1;
			chips.y = 1;
			addChild(chips);
			
			// buy chips
			var buyChips:BuyChipsButton = new BuyChipsButton();
			buyChips.x = 208;
			buyChips.y = 6;
			addChild(buyChips);
			
			// xp progress bar
			_progressVar = new ProgressBar(306, 36, 1);
			_progressVar.x = 247;
			_progressVar.y = 6;
			addChild(_progressVar);
			_progressVar.PercentTo = Main.Instance.Session.Wallet.XPPercent;
			Main.Instance.Session.Wallet.addEventListener(SessionDataEvent.XPChanged, OnXPChanged);
			
			// xp
			var xpProgress:XPProgressTextField = new XPProgressTextField();
			xpProgress.x = 247;
			xpProgress.y = 12;
			addChild(xpProgress);
			
			// level
			var levelInfo:LevelInfoTextField = new LevelInfoTextField();
			levelInfo.x = 559;
			levelInfo.y = 9;
			addChild(levelInfo);
			
			// back to lobby
			var home:HomeButton = new HomeButton();
			home.x = 616;
			home.y = 2;
			addChild(home);
			
			if (!Main.Instance.XServices.Social.IsFacebookLogon)
			{
				var facebook:FacebookButton = new FacebookButton();
				facebook.x = 662;
				facebook.y = 2;
				addChild(facebook);
			}
			
			// settings
			var settings:SettingsButton = new SettingsButton();
			settings.x = 708;
			settings.y = 2;
			addChild(settings);
			
			// volume
			var volumeButton:VolumeTopBarButton = new VolumeTopBarButton();
			volumeButton.x = 754;
			volumeButton.y = 2;
			addChild(volumeButton);
		}
		public override function Dispose():void
		{
			Main.Instance.Session.Wallet.removeEventListener(SessionDataEvent.XPChanged, OnXPChanged);
			
			if (_progressVar)
			{
				_progressVar.Dispose();
				_progressVar = null;
			}
			
			super.Dispose();
		}
		
		// events
		protected function OnXPChanged(event:Event):void
		{
			_progressVar.PercentTo = Main.Instance.Session.Wallet.XPPercent;
		}
	}
}