package com.gotchaslots.common.ui.common.components.buttons
{
	import com.gotchaslots.common.assets.machinesList.MachinesListEmbed;
	import com.gotchaslots.common.ui.common.components.base.BaseClickableButton;
	
	public class NextButton extends BaseClickableButton
	{
		// class
		public function NextButton(onClickDispatch:Function)
		{
			super(44, 44, onClickDispatch, null, new MachinesListEmbed.NextNormal(), new MachinesListEmbed.NextSelected(), Number.NaN);
		}
	}
}