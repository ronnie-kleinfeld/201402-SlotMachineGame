package com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.risks
{
	import com.gotchaslots.slots.assets.bonusGame.higherLower.HigherLowerEmbed;
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	import com.gotchaslots.slots.utils.sounds.SlotsSoundsManager;
	
	import flash.events.MouseEvent;
	
	public class LowerButton extends BaseClickableButton
	{
		// class
		public function LowerButton()
		{
			super(60, 60, null, null, new HigherLowerEmbed.Lower(), new HigherLowerEmbed.Lower());
		}
		
		// events
		protected override function OnClick(event:MouseEvent):void
		{
			super.OnClick(event);
			Main.Instance.Sounds.Play(SlotsSoundsManager.Down);
		}
	}
}