package com.gotchaslots.common.data.session.level
{
	import com.gotchaslots.common.data.Main;
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	
	public class LevelChipsData extends EventDispatcherEx
	{
		// members
		private var _levelNumber:int;
		private var _chips:Number;
		private var _allowedBetsChipsIndex:int;
		
		// properties
		public function get LevelNumber():int
		{
			return _levelNumber;
		}
		public function get Chips():Number
		{
			return _chips;
		}
		public function get AllowedBetsChipsIndex():int
		{
			return _allowedBetsChipsIndex;
		}
		
		// class
		public function LevelChipsData(levelNumber:int, chips:Number)
		{
			super();
			
			_levelNumber = levelNumber;
			_chips = chips;
			_allowedBetsChipsIndex = Main.Instance.Application.GetBetIndexByBetChips(_chips);
		}
	}
}