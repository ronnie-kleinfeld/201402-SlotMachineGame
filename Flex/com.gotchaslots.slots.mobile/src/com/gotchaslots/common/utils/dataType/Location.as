package com.gotchaslots.common.utils.dataType
{
	public class Location
	{
		// members
		private var _x:int;
		private var _y:int;
		
		// properties
		public function get X():int
		{
			return _x;
		}
		public function get Y():int
		{
			return _y;
		}

		// class
		public function Location(x:int, y:int)
		{
			_x = x;
			_y = y;
		}
	}
}