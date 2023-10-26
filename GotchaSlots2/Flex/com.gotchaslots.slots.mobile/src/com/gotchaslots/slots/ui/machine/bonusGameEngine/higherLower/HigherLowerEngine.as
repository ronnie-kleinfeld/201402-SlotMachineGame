package com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower
{
	import com.gotchaslots.slots.assets.bonusGame.higherLower.HigherLowerEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.bonusGame.higherLower.HigherLowerData;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.base.BaseBonusGameEngine;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.payouts.PayoutsPanel;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.risks.HigherButton;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.risks.LowerButton;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.risks.NextSpinTextField;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.risks.RecentRandomTextField;
	import com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.spinner.SpinnerPanel;
	import com.gotchaslots.common.ui.notifications.popup.textFields.PopupTitleTextField;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HigherLowerEngine extends BaseBonusGameEngine
	{
		// members
		private var _recentRandom:RecentRandomTextField;
		private var _payouts:PayoutsPanel;
		private var _spinner:SpinnerPanel;
		private var _lower:LowerButton;
		private var _higher:HigherButton;
		private var _wonCheck:Bitmap;
		
		// class
		public function HigherLowerEngine(higherLower:HigherLowerData)
		{
			super(higherLower);
			
			var title:PopupTitleTextField = new PopupTitleTextField(W, "Higher or Lower what do you think?");
			title.y = 30;
			addChild(title);
			
			var nextSpin:NextSpinTextField = new NextSpinTextField();
			nextSpin.x = 79 + (266 - nextSpin.width) / 2;
			nextSpin.y = title.y + title.height + 20;
			addChild(nextSpin);
			
			_recentRandom = new RecentRandomTextField();
			_recentRandom.x = 79 + (266 - _recentRandom.width) / 2;
			_recentRandom.y = nextSpin.y + nextSpin.height + 20;
			addChild(_recentRandom);
			
			_spinner = new SpinnerPanel(higherLower);
			_spinner.addEventListener(Event.COMPLETE, onSpinnerPanelComplete);
			_spinner.x = 79 + 73;
			_spinner.y = _recentRandom.y + _recentRandom.height - 6;
			addChild(_spinner);
			
			_lower = new LowerButton();
			_lower.addEventListener(MouseEvent.CLICK, onLowerClick);
			_lower.x = 79 + 21.5;
			_lower.y = nextSpin.y + nextSpin.height + 15;
			addChild(_lower);
			
			_higher = new HigherButton();
			_higher.addEventListener(MouseEvent.CLICK, onHigherClick);
			_higher.x = 79 + 266 - 21.5 - _higher.width;
			_higher.y = nextSpin.y + nextSpin.height + 15;
			addChild(_higher);
			
			_payouts = new PayoutsPanel(higherLower);
			_payouts.x = 400;
			_payouts.y = 78;
			addChild(_payouts);
			
			_wonCheck = new HigherLowerEmbed.GreenCheck();
			_wonCheck.alpha = 0;
			_wonCheck.width = _wonCheck.height = 34;
			_wonCheck.x = 79 + (266 - _wonCheck.width) / 2;
			_wonCheck.y = _recentRandom.y + _recentRandom.height - _wonCheck.height / 2;
			addChild(_wonCheck);
		}
		
		// methods
		private function DoSpin(isHigher:Boolean):void
		{
			_wonCheck.alpha = 0;
			_spinner.DoSpin(isHigher, HigherLowerData(_bonusGameData));
		}
		protected function onSpinnerPanelComplete(event:Event):void
		{
			if (HigherLowerData(_bonusGameData).CurrentIndex >= 6)
			{
				_payouts.DoWon(6);
				DoBonusGameComplete();
			}
			else
			{
				if (HigherLowerData(_bonusGameData).CurrentHigherLowerPayout().IsWon)
				{
					_lower.SetEnabled();
					_higher.SetEnabled();
					TweenLite.to(_wonCheck, 0.2, {alpha:1});
					Main.Instance.Sounds.Play(SlotsSoundsManager.Won);
					_payouts.DoWon(HigherLowerData(_bonusGameData).CurrentHigherLowerPayout().ID);
				}
				else
				{
					Main.Instance.Sounds.Play(SlotsSoundsManager.NoWin);
					DoBonusGameComplete();
				}
			}
		}
		
		// events
		protected function onLowerClick(event:MouseEvent):void
		{
			_lower.SetDisabled();
			_higher.SetDisabled();
			Main.Instance.Sounds.Play(SlotsSoundsManager.Click);
			_recentRandom.DoWon(HigherLowerData(_bonusGameData).CurrentHigherLowerPayout().Random);
			HigherLowerData(_bonusGameData).CurrentIndex++;
			DoSpin(false);
		}
		protected function onHigherClick(event:MouseEvent):void
		{
			_lower.SetDisabled();
			_higher.SetDisabled();
			Main.Instance.Sounds.Play(SlotsSoundsManager.Click);
			_recentRandom.DoWon(HigherLowerData(_bonusGameData).CurrentHigherLowerPayout().Random);
			HigherLowerData(_bonusGameData).CurrentIndex++;
			DoSpin(true);
		}
	}
}