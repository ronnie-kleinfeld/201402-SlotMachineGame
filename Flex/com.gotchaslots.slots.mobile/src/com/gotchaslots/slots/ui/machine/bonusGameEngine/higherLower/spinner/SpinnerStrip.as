package com.gotchaslots.slots.ui.machine.bonusGameEngine.higherLower.spinner
{
	import com.gotchaslots.common.ui.common.components.base.BaseBG;
	
	public class SpinnerStrip extends BaseBG
	{
		// properties
		protected override function get FrameCorner():Number
		{
			return 10;
		}
		
		// class
		public function SpinnerStrip(prevRandom:int, random:int)
		{
			super(0, 0);
			
			CreateTextField(prevRandom);
			
			for (var i:int = 0; i < 20; i++)
			{
				CreateTextField(Math.ceil((Math.random() * 9)));
			}
			
			CreateTextField(random);
		}
		
		// methods
		private function CreateTextField(random:int):void
		{
			var tf:SpinnerTextField = new SpinnerTextField(random);
			tf.x = tf.width * numChildren;
			addChild(tf);
		}
	}
}