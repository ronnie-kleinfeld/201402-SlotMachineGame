package com.gotchaslots.common.utils.dataType
{
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;

	public class BaseIDData extends EventDispatcherEx
	{
		// members
		private var _id:int;
		
		// properties
		public function get ID():int
		{
			return _id;
		}
		
		// class
		public function BaseIDData(id:int)
		{
			super();
			
			_id = id;
		}
	}
}