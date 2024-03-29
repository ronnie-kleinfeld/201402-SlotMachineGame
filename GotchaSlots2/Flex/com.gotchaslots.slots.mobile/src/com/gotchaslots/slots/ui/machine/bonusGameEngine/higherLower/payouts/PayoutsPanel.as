package com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.payouts
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.slots.data.machine.bonusGame.higherLower.HigherLowerData;
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	
	public class PayoutsPanel extends BaseBG
	{
		// members
		private var _payoutsSteps:Vector.<PayoutStep>;
		
		// properties
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		// class
		public function PayoutsPanel(higherLowerBonusGame:HigherLowerData)
		{
			super(306, 310);
			
			_payoutsSteps = new Vector.<PayoutStep>();
			for (var i:int = 0; i < 7; i++)
			{
				var payoutStep:PayoutStep = new PayoutStep(((10 - i) / 10 * 0.7 + 0.3) * W, Main.Instance.ActiveMachine.SelectedBetChips * higherLowerBonusGame.HigherLowerPayout(6 - i).Ratio);
				payoutStep.x = (W - payoutStep.width) / 2;
				payoutStep.y = i * 38;
				addChild(payoutStep);
			}
			
			DoWon(0);
		}
		
		// methods
		public function DoWon(index:int):void
		{
			for (var i:int = 0; i < 7; i++)
			{
				var payoutStep:PayoutStep = PayoutStep(getChildAt(numChildren - i - 1));
				if (i <= index)
				{
					payoutStep.SetAsWon();
				}
				else if (i == index + 1)
				{
					payoutStep.SetAsCurrent();
				}
			}
		}
	}
}