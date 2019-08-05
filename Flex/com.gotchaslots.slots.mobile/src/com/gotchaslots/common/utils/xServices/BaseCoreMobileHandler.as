package com.gotchaslots.common.utils.xServices
{
	import com.gotchaslots.common.utils.ex.EventDispatcherEx;
	import com.milkmangames.nativeextensions.CoreMobile;

	public class BaseCoreMobileHandler extends EventDispatcherEx
	{// members
		protected var _initialized:Boolean;
		
		// class
		public function BaseCoreMobileHandler()
		{
			super();
		}
		protected function Init():Boolean
		{
			if (!_initialized)
			{
				if (CoreMobile.isSupported())
				{
					CoreMobile.create();
					
					_initialized = true;
				}
				else
				{
					_initialized = false;
				}
			}
			
			return _initialized;
		}
	}
}